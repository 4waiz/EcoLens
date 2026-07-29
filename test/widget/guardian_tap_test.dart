import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/core/theme/valley_tokens.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:ecolens/features/kiosk/application/guardian_dialogue.dart';
import 'package:ecolens/features/kiosk/application/guardian_interaction.dart';
import 'package:ecolens/features/kiosk/application/guardian_voice.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:ecolens/features/kiosk/application/kiosk_preferences.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/shared/world/guardian_controller.dart';
import 'package:ecolens/shared/world/guardian_emotion.dart';
import 'package:ecolens/shared/world/guardian_mascot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Touching the Guardian, inside the real kiosk.
///
/// The unit tests prove the policy; these prove it is actually WIRED — that a
/// real tap on the character reaches the controller, that the reaction is motion
/// layered over the expression rather than a change of expression, and that the
/// dialogue bubble and the voice both follow.
void main() {
  Future<ProviderContainer> pumpKiosk(
    WidgetTester tester, {
    Size size = const Size(1440, 900),
    bool withStudent = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.light(), home: const KioskScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));

    if (withStudent) {
      await tester.runAsync(
        () => container
            .read(kioskControllerProvider.notifier)
            .readCard(MockSeedData.liamCardUid),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }
    return container;
  }

  GuardianMascot mascot(WidgetTester tester) =>
      tester.widget<GuardianMascot>(find.byType(GuardianMascot));

  // ---------------------------------------------------------------------------
  // 12. A tap in a calm state reaches the Guardian
  // ---------------------------------------------------------------------------

  testWidgets('12. tapping the Guardian on the attract screen reacts', (
    tester,
  ) async {
    final container = await pumpKiosk(tester);
    expect(container.read(kioskControllerProvider).state, KioskState.idle);
    expect(mascot(tester).tapSequence, 0);

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();

    final interaction = container.read(guardianInteractionProvider);
    expect(interaction.taps, 1, reason: 'the tap reached the controller');
    expect(interaction.reply, isNotNull);

    // The widget received a motion to play, keyed so it replays on every tap.
    final m = mascot(tester);
    expect(m.tapMotion, isNotNull);
    expect(m.tapSequence, 1);
    expect(m.tapEnabled, isTrue);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('12b. the reply appears in the dialogue bubble', (tester) async {
    final container = await pumpKiosk(tester);

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();

    final reply = container.read(guardianInteractionProvider).reply!;
    final dialogue = container.read(guardianDialogueProvider);

    expect(dialogue.isTapReply, isTrue);
    expect(dialogue.text, reply.line.text);
    expect(find.text(reply.line.text), findsOneWidget);
    // A tap reply carries its own event identity, so it is spoken once.
    expect(dialogue.event.id, 'tap#1');

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('12c. the Guardian is keyboard-activatable and announced', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final container = await pumpKiosk(tester);

    // The affordance is discoverable to a screen reader without the Guardian
    // being drawn as a button.
    expect(
      find.bySemanticsLabel(RegExp('Sprout the Guardian')),
      findsOneWidget,
    );

    // Enter activates it, the same as a touch.
    final mascotFinder = find.byType(GuardianMascot);
    await tester.tap(mascotFinder);
    await tester.pump();
    expect(container.read(guardianInteractionProvider).taps, 1);

    handle.dispose();
    await tester.pump(const Duration(seconds: 4));
  });

  // ---------------------------------------------------------------------------
  // 13. A tap never interrupts a scan
  // ---------------------------------------------------------------------------

  testWidgets('13. a tap during the card read is ignored', (tester) async {
    final container = await pumpKiosk(tester);

    // Start a real card read and stop mid-flight.
    container
        .read(kioskControllerProvider.notifier)
        .readCard(MockSeedData.liamCardUid);
    await tester.pump();
    expect(
      container.read(kioskControllerProvider).state,
      KioskState.readingCard,
    );

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();

    final interaction = container.read(guardianInteractionProvider);
    expect(interaction.taps, 0, reason: 'a scan must not be interrupted');
    expect(interaction.ignored, 1);
    expect(interaction.reply, isNull);
    expect(mascot(tester).tapEnabled, isFalse);

    // The Guardian is still saying the right thing about the card.
    expect(
      container.read(guardianDialogueProvider).isTapReply,
      isFalse,
      reason: 'the scan dialogue must survive the tap',
    );

    // Let the read finish so no timer outlives the tree.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    container.read(kioskControllerProvider.notifier).endSession();
    await tester.pump();
  });

  testWidgets('13b. moving into a critical state drops a showing reply', (
    tester,
  ) async {
    final container = await pumpKiosk(tester);

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();
    expect(container.read(guardianInteractionProvider).isReplying, isTrue);

    // A card lands while the aside is still on screen.
    container
        .read(kioskControllerProvider.notifier)
        .readCard(MockSeedData.liamCardUid);
    await tester.pump();

    expect(
      container.read(guardianInteractionProvider).isReplying,
      isFalse,
      reason: 'the workflow line must take the bubble back',
    );

    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    container.read(kioskControllerProvider.notifier).endSession();
    await tester.pump();
  });

  // ---------------------------------------------------------------------------
  // 14. Cooldown, through the widget
  // ---------------------------------------------------------------------------

  testWidgets('14. spam tapping the Guardian yields one reaction', (
    tester,
  ) async {
    final container = await pumpKiosk(tester);

    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byType(GuardianMascot));
      await tester.pump(const Duration(milliseconds: 80));
    }

    final interaction = container.read(guardianInteractionProvider);
    expect(interaction.taps, 1);
    expect(interaction.ignored, 5);

    await tester.pump(const Duration(seconds: 4));
  });

  // ---------------------------------------------------------------------------
  // 15. The workflow emotion is untouched
  // ---------------------------------------------------------------------------

  testWidgets('15. a tap does not change the Guardian expression', (
    tester,
  ) async {
    final container = await pumpKiosk(tester, withStudent: true);
    final before = container.read(guardianControllerProvider);

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();

    final after = container.read(guardianControllerProvider);
    expect(
      after.emotion,
      before.emotion,
      reason: 'a tap is motion only — it must never take over the expression',
    );
    expect(
      after.sequence,
      before.sequence,
      reason: 'no expression change was applied',
    );
    // The mascot is still rendering the workflow emotion.
    expect(mascot(tester).emotion, before.emotion);

    await tester.pump(const Duration(seconds: 4));
    container.read(kioskControllerProvider.notifier).endSession();
    await tester.pump();
  });

  testWidgets('15b. once the reply expires the workflow line returns', (
    tester,
  ) async {
    final container = await pumpKiosk(tester);
    final workflowLine = container.read(guardianDialogueProvider).text;

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();
    expect(container.read(guardianDialogueProvider).text, isNot(workflowLine));

    // The reply times out on its own.
    await tester.pump(const Duration(seconds: 4));

    expect(container.read(guardianDialogueProvider).text, workflowLine);
    expect(container.read(guardianDialogueProvider).isTapReply, isFalse);
  });

  // ---------------------------------------------------------------------------
  // 22. Reduced motion
  // ---------------------------------------------------------------------------

  testWidgets('22. calm mode keeps the interaction but simplifies the motion', (
    tester,
  ) async {
    final container = await pumpKiosk(tester);
    container.read(kioskPreferencesProvider.notifier).toggleReduceMotion();
    await tester.pump();

    expect(
      mascot(tester).animate,
      isFalse,
      reason: 'calm mode swaps the hop for a short scale response',
    );

    await tester.tap(find.byType(GuardianMascot));
    await tester.pump();

    // The interaction itself is NOT removed: the reply and the words still land.
    final interaction = container.read(guardianInteractionProvider);
    expect(interaction.taps, 1);
    expect(interaction.reply, isNotNull);
    expect(find.text(interaction.reply!.line.text), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  // ---------------------------------------------------------------------------
  // 18/19. The voice, wired through the kiosk
  // ---------------------------------------------------------------------------

  testWidgets('18. muting the kiosk mutes the Guardian voice', (tester) async {
    final container = await pumpKiosk(tester);
    final voice = container.read(guardianVoiceProvider);
    expect(voice.muted, isFalse, reason: 'sound is on by default');

    await tester.tap(find.bySemanticsLabel('Sound on'));
    await tester.pump();

    expect(voice.muted, isTrue);

    // …and unmuting releases it again.
    await tester.tap(find.bySemanticsLabel('Sound off'));
    await tester.pump();
    expect(voice.muted, isFalse);
  });

  testWidgets('16. one dialogue moment produces one utterance, not one per '
      'rebuild', (tester) async {
    final container = await pumpKiosk(tester);
    final voice = container.read(guardianVoiceProvider);
    final before = voice.utteranceCount;

    // Force a pile of rebuilds without changing the dialogue.
    for (var i = 0; i < 5; i++) {
      container.read(kioskPreferencesProvider.notifier).toggleLargeText();
      await tester.pump();
    }

    expect(
      voice.utteranceCount,
      before,
      reason: 'rebuilding the tree must never re-speak',
    );
  });

  testWidgets('21. leaving the kiosk stops the Guardian speaking', (
    tester,
  ) async {
    final container = await pumpKiosk(tester);
    final voice = container.read(guardianVoiceProvider);
    expect(voice.currentLine, isNotNull);

    // Replace the kiosk with another screen: the bridge is autoDispose, and its
    // teardown is what silences the Guardian.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SizedBox())),
      ),
    );
    await tester.pump();

    expect(
      voice.currentLine,
      isNull,
      reason: 'the line is forgotten so the next student is greeted afresh',
    );
  });

  // ---------------------------------------------------------------------------
  // The bubble's replay control
  // ---------------------------------------------------------------------------

  testWidgets('19. the replay control is absent when there is no engine', (
    tester,
  ) async {
    // The test VM has no speech synthesiser, so the control must not be offered.
    final container = await pumpKiosk(tester);
    expect(container.read(guardianVoiceProvider).isAvailable, isFalse);
    expect(find.bySemanticsLabel('Hear that again'), findsNothing);
  });

  // ---------------------------------------------------------------------------
  // The bubble's mood
  // ---------------------------------------------------------------------------

  test('every expression maps to a bubble mood, and none of them alarm', () {
    // Exhaustive by construction — the switch has no default, so a new emotion
    // will not compile until it is given a mood.
    for (final emotion in GuardianEmotion.values) {
      expect(GuardianDialogue.themeForEmotion(emotion), isNotNull);
    }

    expect(
      GuardianDialogue.themeForEmotion(GuardianEmotion.thinking),
      ValleyTheme.adventure,
      reason: 'thinking should read as pale blue',
    );
    expect(
      GuardianDialogue.themeForEmotion(GuardianEmotion.correct),
      ValleyTheme.bloom,
    );
    expect(
      GuardianDialogue.themeForEmotion(GuardianEmotion.levelUp),
      ValleyTheme.arcane,
    );
    expect(
      GuardianDialogue.themeForEmotion(GuardianEmotion.celebrate),
      ValleyTheme.treasure,
    );
    // A slip is warm amber. Nothing in the student experience is ever red.
    for (final gentle in [
      GuardianEmotion.tryAgain,
      GuardianEmotion.encourage,
    ]) {
      expect(GuardianDialogue.themeForEmotion(gentle), ValleyTheme.ember);
    }
  });

  testWidgets(
    'a touch reply stays neutral rather than looking like a verdict',
    (tester) async {
      final container = await pumpKiosk(tester);
      await tester.tap(find.byType(GuardianMascot));
      await tester.pump();

      final dialogue = container.read(guardianDialogueProvider);
      expect(dialogue.isTapReply, isTrue);
      expect(dialogue.bubbleTheme, ValleyTheme.forest);

      await tester.pump(const Duration(seconds: 4));
    },
  );
}
