import 'package:flutter/foundation.dart';

import '../../../domain/enums/waste_category.dart';
import '../../../shared/world/guardian_emotion.dart';

/// One thing the Guardian says.
@immutable
class GuardianLine {
  const GuardianLine({required this.text, this.headline});

  /// Optional bold opener.
  final String? headline;

  /// The message. Kept to roughly one short sentence — this is read across a
  /// room by a child holding a yoghurt pot.
  final String text;
}

/// ---------------------------------------------------------------------------
/// What the Guardian says for each expression.
///
/// Centralised so wording can be reviewed (and later localised) in one place
/// instead of being scattered through screens. Values are interpolated rather
/// than concatenated at call sites, and no student data is baked in here.
///
/// When the app gains an `AppLocalizations`, this class becomes the only thing
/// that needs to change: every screen already asks for a [GuardianLine].
/// ---------------------------------------------------------------------------
abstract final class GuardianSpeech {
  static GuardianLine forEmotion(
    GuardianEmotion emotion, {
    String? firstName,
    String? guardianName,
    String? houseName,
    WasteCategory? category,
    int? level,
    int? itemsToday,
  }) {
    final name = _safeName(firstName);
    final guardian = guardianName ?? 'Sprout';

    return switch (emotion) {
      // Idle and listening mean different things before and after a card is
      // read: on the attract screen the Guardian is inviting a tap, mid-session
      // it is waiting on an item. Same expression, different job — without this
      // split a logged-in student gets told to tap the card they just tapped.
      GuardianEmotion.idle =>
        name == null
            ? GuardianLine(
                headline: 'Welcome to EcoLens!',
                text:
                    "I'm $guardian, Guardian of the valley. Tap your Student ID "
                    "card when you're ready!",
              )
            : GuardianLine(
                text:
                    "Take your time, $name — show me an item when you're ready.",
              ),

      GuardianEmotion.listening =>
        name == null
            ? const GuardianLine(
                text: "Tap your Student ID card when you're ready!",
              )
            : const GuardianLine(text: 'Show me the item you want to recycle.'),

      GuardianEmotion.thinking => const GuardianLine(
        text: 'Let me check that item…',
      ),

      GuardianEmotion.welcome => GuardianLine(
        headline: name == null ? 'Welcome back!' : 'Welcome back, $name!',
        text: houseName == null
            ? "Ready for today's eco-mission?"
            : "Ready for today's eco-mission for $houseName House?",
      ),

      GuardianEmotion.correct => GuardianLine(
        headline: 'Great sorting!',
        text: category == null
            ? 'That one went exactly where it belongs.'
            : 'That belongs in ${category.label}.',
      ),

      GuardianEmotion.tryAgain => const GuardianLine(
        headline: 'Almost!',
        text: 'Think about what the item is made from.',
      ),

      GuardianEmotion.encourage => const GuardianLine(
        headline: "You've got this.",
        text: "Let's try another portal — I'll help you.",
      ),

      GuardianEmotion.celebrate => GuardianLine(
        headline: 'Amazing!',
        text: itemsToday == null
            ? 'You helped Guardian Valley today.'
            : 'You sorted $itemsToday items and helped Guardian Valley today.',
      ),

      GuardianEmotion.levelUp => GuardianLine(
        headline: 'Level up!',
        text: level == null
            ? 'You reached a new Eco Guardian level!'
            : 'You reached Eco Guardian Level $level!',
      ),

      GuardianEmotion.goodbye => GuardianLine(
        headline: name == null ? 'Great work!' : 'Great work, $name.',
        text: 'See you next time!',
      ),
    };
  }

  /// Names come from student records and can be long or oddly cased. Trim to
  /// something a speech bubble can hold; the widget also ellipsises, so this is
  /// belt and braces rather than the only guard.
  static String? _safeName(String? raw) {
    final name = raw?.trim();
    if (name == null || name.isEmpty) return null;
    if (name.length <= 14) return name;
    return '${name.substring(0, 13)}…';
  }
}
