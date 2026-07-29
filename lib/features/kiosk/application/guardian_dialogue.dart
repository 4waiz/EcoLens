import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/valley_tokens.dart';
import '../../../domain/enums/kiosk_state.dart';
import '../../../shared/world/guardian_controller.dart';
import '../../../shared/world/guardian_emotion.dart';
import 'guardian_interaction.dart';
import 'guardian_speech.dart';
import 'guardian_voice.dart';
import 'kiosk_controller.dart';
import 'kiosk_preferences.dart';

/// ---------------------------------------------------------------------------
/// The one thing the Guardian is saying right now.
///
/// Both the speech bubble and the voice read from here, which is what keeps
/// them in step: whatever is written is exactly what is spoken, and neither can
/// drift from the other. It also means the *dedupe* has a single anchor — the
/// event id — so a rebuild can never produce a second utterance.
///
/// Precedence is deliberately simple: a tap reply, if the Guardian has one to
/// give, otherwise the workflow line for the current expression.
/// ---------------------------------------------------------------------------
@immutable
class GuardianDialogue {
  const GuardianDialogue({
    required this.event,
    required this.emotion,
    required this.isTapReply,
  });

  /// What to speak, and the identity that makes speaking it idempotent.
  final GuardianSpeechEvent event;

  /// The expression the bubble should be themed for.
  final GuardianEmotion emotion;

  /// True while the Guardian is answering a touch rather than driving the flow.
  final bool isTapReply;

  String get text => event.text;
  String? get headline => event.headline;

  /// The bubble's mood.
  ///
  /// Cream and green when the Guardian is simply talking, pale blue while it is
  /// thinking, green for a good sort, gold for a celebration, purple for a
  /// level-up — and warm amber, never red, when something needs another go. A
  /// touch reply is always neutral: a friendly aside should not look like a
  /// verdict on what the student just did.
  ValleyTheme get bubbleTheme =>
      isTapReply ? ValleyTheme.forest : themeForEmotion(emotion);

  static ValleyTheme themeForEmotion(GuardianEmotion emotion) =>
      switch (emotion) {
        GuardianEmotion.correct => ValleyTheme.bloom,
        GuardianEmotion.celebrate => ValleyTheme.treasure,
        GuardianEmotion.levelUp => ValleyTheme.arcane,
        GuardianEmotion.tryAgain ||
        GuardianEmotion.encourage => ValleyTheme.ember,
        GuardianEmotion.thinking => ValleyTheme.adventure,
        GuardianEmotion.idle ||
        GuardianEmotion.listening ||
        GuardianEmotion.welcome ||
        GuardianEmotion.goodbye => ValleyTheme.forest,
      };
}

/// Derives the current dialogue from the Guardian's expression, the live
/// session and any accepted tap.
final guardianDialogueProvider = Provider.autoDispose<GuardianDialogue>((ref) {
  final guardian = ref.watch(guardianControllerProvider);
  final session = ref.watch(kioskControllerProvider);
  final interaction = ref.watch(guardianInteractionProvider);

  final reply = interaction.reply;
  if (reply != null) {
    return GuardianDialogue(
      emotion: guardian.emotion,
      isTapReply: true,
      event: GuardianSpeechEvent(
        // Keyed on the tap counter, so two identical replies both play.
        id: 'tap#${reply.sequence}',
        text: reply.line.text,
        headline: reply.line.headline,
        // Above a routine prompt, below a celebration — a poke should not talk
        // over a level-up.
        priority: 2,
      ),
    );
  }

  final line = GuardianSpeech.forEmotion(
    guardian.emotion,
    firstName: session.student?.firstName,
    guardianName: session.avatar?.name,
    houseName: session.house?.name,
    category: session.lastOutcome?.correctCategory ?? session.routedCategory,
    level: session.avatar?.level,
    itemsToday: session.itemsThisSession > 0 ? session.itemsThisSession : null,
    readingCard: session.state == KioskState.readingCard,
  );

  return GuardianDialogue(
    emotion: guardian.emotion,
    isTapReply: false,
    event: GuardianSpeechEvent(
      // `sequence` increments only on an APPLIED expression change, never on a
      // rebuild — so this id is exactly "one dialogue moment".
      id: '${guardian.emotion.name}#${guardian.sequence}',
      text: line.text,
      headline: line.headline,
      priority: guardian.emotion.priority,
    ),
  );
});

/// Connects the dialogue to the voice, and the voice to the mute control.
///
/// Watch this from the kiosk surface so it lives exactly as long as the kiosk
/// does: its disposal is what guarantees a sentence never carries on playing
/// over the next route.
///
/// It *listens* rather than watches, so no rebuild can replay a line.
final guardianVoiceBridgeProvider = Provider.autoDispose<void>((ref) {
  final voice = ref.read(guardianVoiceProvider);

  // Mute is a hard gate, applied before anything else and honoured live.
  voice.setMuted(!ref.read(kioskPreferencesProvider).soundEnabled);
  ref.listen<KioskPreferences>(kioskPreferencesProvider, (previous, next) {
    if (previous?.soundEnabled == next.soundEnabled) return;
    voice.setMuted(!next.soundEnabled);
  });

  ref.listen<GuardianDialogue>(guardianDialogueProvider, (previous, next) {
    if (previous?.event.id == next.event.id) return;
    voice.announce(next.event);
  }, fireImmediately: true);

  // Leaving the kiosk stops the Guardian mid-sentence and forgets the line, so
  // the next student is greeted out loud even if the words are identical.
  ref.onDispose(voice.reset);
});
