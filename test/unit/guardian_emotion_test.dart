import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:ecolens/domain/models/models.dart';
import 'package:ecolens/features/kiosk/application/guardian_director.dart';
import 'package:ecolens/features/kiosk/application/guardian_speech.dart';
import 'package:ecolens/features/kiosk/application/kiosk_session_state.dart';
import 'package:ecolens/shared/world/guardian_controller.dart';
import 'package:ecolens/shared/world/guardian_emotion.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for the Guardian emotion system: the asset contract, the
/// transition policy, and the mapping from the kiosk state machine.
void main() {
  const student = Student(
    id: 'stu-liam',
    studentNumber: 'STU-2026-0417',
    firstName: 'Liam',
    lastName: 'Carter',
    grade: 4,
    className: '4B',
    houseId: 'house-taurus',
    avatarId: 'avatar-liam',
  );

  SessionOutcomeView outcome({
    bool correct = true,
    bool stageChanged = false,
    bool bonus = false,
    bool capReached = false,
  }) => SessionOutcomeView(
    wasCorrect: correct,
    isLowConfidence: false,
    selected: WasteCategory.plastic,
    correctCategory: WasteCategory.plastic,
    pointsAwarded: correct ? 5 : 0,
    bonusPoints: 0,
    xpAwarded: correct ? 5 : 0,
    housePoints: correct ? 5 : 0,
    newStreak: 1,
    bonusApplied: bonus,
    dailyCapReached: capReached,
    newTotalXp: 100,
    newAvailablePoints: 20,
    stageChanged: stageChanged,
    newStage: null,
  );

  KioskSessionState at(
    KioskState state, {
    bool withStudent = true,
    SessionOutcomeView? result,
  }) => KioskSessionState(
    state: state,
    student: withStudent ? student : null,
    lastOutcome: result,
  );

  // ---------------------------------------------------------------------------
  // 1–3. The asset contract
  // ---------------------------------------------------------------------------

  group('asset contract', () {
    test('1. every emotion maps to a distinct asset under assets/guardian', () {
      final paths = <String>{};
      for (final e in GuardianEmotion.values) {
        expect(
          e.assetPath,
          startsWith('assets/guardian/guardian_'),
          reason: '${e.name} must resolve to a guardian asset',
        );
        expect(e.assetPath, endsWith('.webp'));
        expect(paths.add(e.assetPath), isTrue, reason: '${e.name} duplicates');
      }
      expect(paths, hasLength(GuardianEmotion.values.length));
    });

    test('every emotion declares a motion profile with a hop', () {
      for (final e in GuardianEmotion.values) {
        expect(
          e.motion.jump,
          greaterThan(0),
          reason: '${e.name} should hop a little when it appears',
        );
        expect(e.motion.jumps, greaterThanOrEqualTo(1));
        expect(e.motion.period.inMilliseconds, greaterThan(0));
      }
    });

    test('transient emotions all carry a positive hold so they can decay', () {
      for (final e in GuardianEmotion.values.where((e) => e.isTransient)) {
        expect(
          e.minimumHold,
          greaterThan(Duration.zero),
          reason: '${e.name} is transient and would otherwise stick forever',
        );
      }
    });

    test(
      'only three frames need an alignment correction, and all are tiny',
      () {
        final corrected = GuardianEmotion.values
            .where((e) => e.layout.translation != Offset.zero)
            .toSet();
        expect(corrected, {
          GuardianEmotion.celebrate,
          GuardianEmotion.levelUp,
          GuardianEmotion.goodbye,
        });
        for (final e in GuardianEmotion.values) {
          expect(e.layout.translation.distance, lessThan(0.02));
          expect(e.layout.scale, 1.0);
        }
      },
    );
  });

  // ---------------------------------------------------------------------------
  // 4–12. State → emotion mapping
  // ---------------------------------------------------------------------------

  group('kiosk state maps to the right expression', () {
    test('4. a valid Student ID leads to welcome', () {
      expect(
        GuardianDirector.emotionFor(at(KioskState.studentRecognised)),
        GuardianEmotion.welcome,
      );
    });

    test('an unreadable card is met with try-again, never an error face', () {
      expect(
        GuardianDirector.emotionFor(at(KioskState.studentNotFound)),
        GuardianEmotion.tryAgain,
      );
    });

    test('5. item processing shows thinking', () {
      for (final s in [
        KioskState.readingCard,
        KioskState.capturingImage,
        KioskState.analysingImage,
        KioskState.processingAnswer,
      ]) {
        expect(GuardianDirector.emotionFor(at(s)), GuardianEmotion.thinking);
      }
    });

    test('waiting on the student shows listening', () {
      for (final s in [
        KioskState.waitingForCard,
        KioskState.readyToScan,
        KioskState.classificationReady,
        KioskState.waitingForStudentAnswer,
      ]) {
        expect(GuardianDirector.emotionFor(at(s)), GuardianEmotion.listening);
      }
    });

    test('6. the correct category leads to correct', () {
      expect(
        GuardianDirector.emotionFor(
          at(KioskState.correctFeedback, result: outcome()),
        ),
        GuardianEmotion.correct,
      );
    });

    test('7. the first wrong category leads to tryAgain', () {
      expect(
        GuardianDirector.emotionFor(
          at(KioskState.incorrectFeedback, result: outcome(correct: false)),
          wrongStreak: 1,
        ),
        GuardianEmotion.tryAgain,
      );
    });

    test('8. repeated wrong attempts switch to encouragement', () {
      expect(
        GuardianDirector.emotionFor(
          at(KioskState.incorrectFeedback, result: outcome(correct: false)),
          wrongStreak: 2,
        ),
        GuardianEmotion.encourage,
      );
    });

    test('9. completing the daily goal leads to celebrate', () {
      expect(
        GuardianDirector.emotionFor(
          at(KioskState.rewardSummary, result: outcome(capReached: true)),
        ),
        GuardianEmotion.celebrate,
      );
    });

    test('10. an XP level increase leads to levelUp, outranking celebrate', () {
      expect(
        GuardianDirector.emotionFor(
          at(
            KioskState.correctFeedback,
            result: outcome(stageChanged: true, bonus: true),
          ),
        ),
        GuardianEmotion.levelUp,
      );
    });

    test('11. session completion leads to goodbye', () {
      expect(
        GuardianDirector.emotionFor(at(KioskState.sessionComplete)),
        GuardianEmotion.goodbye,
      );
    });

    test('a recoverable error stays calm rather than alarming', () {
      for (final s in [KioskState.maintenance, KioskState.error]) {
        expect(GuardianDirector.emotionFor(at(s)), GuardianEmotion.tryAgain);
      }
    });

    test('every kiosk state has a mapping', () {
      for (final s in KioskState.values) {
        expect(
          () => GuardianDirector.emotionFor(at(s)),
          returnsNormally,
          reason: '${s.name} is unmapped',
        );
      }
    });
  });

  // ---------------------------------------------------------------------------
  // 12–13. Transition policy
  // ---------------------------------------------------------------------------

  group('transition policy', () {
    test('12. a session reset clears the student and returns to idle', () {
      final controller = GuardianController();
      addTearDown(controller.dispose);

      controller.request(GuardianEmotion.celebrate);
      expect(controller.state.emotion, GuardianEmotion.celebrate);

      controller.reset();
      expect(controller.state.emotion, GuardianEmotion.idle);
      expect(controller.state.holding, isFalse);
    });

    test(
      '13. a celebration is not immediately overwritten by routine state',
      () {
        final controller = GuardianController();
        addTearDown(controller.dispose);

        controller.request(GuardianEmotion.celebrate);
        // Everything the kiosk would normally emit right afterwards.
        controller.request(GuardianEmotion.idle);
        controller.request(GuardianEmotion.listening);
        controller.request(GuardianEmotion.thinking);

        expect(controller.state.emotion, GuardianEmotion.celebrate);
        expect(controller.state.holding, isTrue);
      },
    );

    test('a queued request is applied once the hold expires', () {
      fakeAsync((async) {
        final controller = GuardianController();
        controller.request(GuardianEmotion.correct);
        controller.request(GuardianEmotion.listening);
        expect(controller.state.emotion, GuardianEmotion.correct);

        async.elapse(GuardianEmotion.correct.minimumHold + _tick);
        expect(controller.state.emotion, GuardianEmotion.listening);
        controller.dispose();
      });
    });

    test('a transient emotion decays back to idle on its own', () {
      fakeAsync((async) {
        final controller = GuardianController();
        controller.request(GuardianEmotion.correct);
        async.elapse(GuardianEmotion.correct.minimumHold + _tick);
        expect(controller.state.emotion, GuardianEmotion.idle);
        controller.dispose();
      });
    });

    test('higher priority interrupts a hold immediately', () {
      final controller = GuardianController();
      addTearDown(controller.dispose);

      controller.request(GuardianEmotion.correct);
      controller.request(GuardianEmotion.levelUp);
      expect(controller.state.emotion, GuardianEmotion.levelUp);
    });

    test('the same emotion twice replays it once the hold has passed', () {
      fakeAsync((async) {
        final controller = GuardianController();
        controller.request(GuardianEmotion.correct);
        final first = controller.state.sequence;

        // Inside the hold: no replay.
        controller.request(GuardianEmotion.correct);
        expect(controller.state.sequence, first);

        async.elapse(GuardianEmotion.correct.minimumHold + _tick);
        controller.request(GuardianEmotion.correct);
        expect(controller.state.sequence, greaterThan(first));
        controller.dispose();
      });
    });

    test('24. duplicate cues from rebuilds are not emitted twice', () {
      final cues = <GuardianSoundCue>[];
      final controller = GuardianController(onSound: cues.add);
      addTearDown(controller.dispose);

      // The same moment arriving several times in one frame.
      controller.request(GuardianEmotion.correct);
      controller.request(GuardianEmotion.correct);
      controller.playCue(GuardianSoundCue.correct);

      expect(cues, [GuardianSoundCue.correct]);
    });
  });

  // ---------------------------------------------------------------------------
  // The director's memory
  // ---------------------------------------------------------------------------

  group('director', () {
    test('counts consecutive mistakes and escalates to encouragement', () {
      final controller = GuardianController();
      addTearDown(controller.dispose);
      final director = GuardianDirector(controller);

      director.onKioskState(at(KioskState.waitingForStudentAnswer));
      director.onKioskState(
        at(KioskState.incorrectFeedback, result: outcome(correct: false)),
      );
      expect(director.wrongStreak, 1);
      expect(controller.state.emotion, GuardianEmotion.tryAgain);

      director.onKioskState(at(KioskState.waitingForStudentAnswer));
      director.onKioskState(
        at(KioskState.incorrectFeedback, result: outcome(correct: false)),
      );
      expect(director.wrongStreak, 2);
    });

    test('a correct answer clears the mistake streak', () {
      final controller = GuardianController();
      addTearDown(controller.dispose);
      final director = GuardianDirector(controller);

      director.onKioskState(
        at(KioskState.incorrectFeedback, result: outcome(correct: false)),
      );
      expect(director.wrongStreak, 1);
      director.onKioskState(at(KioskState.correctFeedback, result: outcome()));
      expect(director.wrongStreak, 0);
    });

    test('the same state repeated does not re-fire the expression', () {
      final cues = <GuardianSoundCue>[];
      final controller = GuardianController(onSound: cues.add);
      addTearDown(controller.dispose);
      final director = GuardianDirector(controller);

      final snapshot = at(KioskState.studentRecognised);
      director.onKioskState(snapshot);
      final sequence = controller.state.sequence;
      for (var i = 0; i < 5; i++) {
        director.onKioskState(snapshot);
      }
      expect(controller.state.sequence, sequence);
      expect(cues, hasLength(1));
    });

    test(
      'a transient moment rests on listening while a student is present',
      () {
        final withStudent = at(KioskState.studentRecognised);
        expect(
          GuardianDirector.restingFor(withStudent),
          GuardianEmotion.listening,
          reason: 'welcome is a moment; the Guardian then waits on the student',
        );
        expect(
          GuardianDirector.restingFor(at(KioskState.idle, withStudent: false)),
          GuardianEmotion.idle,
        );
      },
    );

    test('a cheer mid-session decays to listening, not the attract face', () {
      fakeAsync((async) {
        final controller = GuardianController();
        final director = GuardianDirector(controller);
        director.onKioskState(at(KioskState.waitingForStudentAnswer));
        director.onKioskState(
          at(KioskState.correctFeedback, result: outcome()),
        );
        expect(controller.state.emotion, GuardianEmotion.correct);

        async.elapse(GuardianEmotion.correct.minimumHold + _tick);
        expect(controller.state.emotion, GuardianEmotion.listening);
        controller.dispose();
      });
    });

    test('returning to an empty idle wipes the previous student entirely', () {
      final controller = GuardianController();
      addTearDown(controller.dispose);
      final director = GuardianDirector(controller);

      director.onKioskState(
        at(KioskState.incorrectFeedback, result: outcome(correct: false)),
      );
      director.onKioskState(at(KioskState.idle, withStudent: false));

      expect(director.wrongStreak, 0);
      expect(controller.state.emotion, GuardianEmotion.idle);
    });
  });

  // ---------------------------------------------------------------------------
  // Speech
  // ---------------------------------------------------------------------------

  group('speech', () {
    test('every emotion has a line, and none is empty', () {
      for (final e in GuardianEmotion.values) {
        final line = GuardianSpeech.forEmotion(e, firstName: 'Liam');
        expect(line.text.trim(), isNotEmpty, reason: e.name);
        expect(line.text.length, lessThan(120), reason: '${e.name} too long');
      }
    });

    test('student values are interpolated, not hardcoded', () {
      final welcome = GuardianSpeech.forEmotion(
        GuardianEmotion.welcome,
        firstName: 'Liam',
        houseName: 'Taurus',
      );
      expect(welcome.headline, contains('Liam'));
      expect(welcome.text, contains('Taurus'));

      final correct = GuardianSpeech.forEmotion(
        GuardianEmotion.correct,
        category: WasteCategory.paper,
      );
      expect(correct.text, contains('Paper'));

      final level = GuardianSpeech.forEmotion(
        GuardianEmotion.levelUp,
        level: 7,
      );
      expect(level.text, contains('7'));
    });

    test('22. an absurdly long student name is trimmed before it is shown', () {
      final line = GuardianSpeech.forEmotion(
        GuardianEmotion.goodbye,
        firstName: 'Bartholomewquintessential',
      );
      expect(line.headline!.length, lessThan(30));
      expect(line.headline, contains('…'));
    });

    test('a missing name degrades to a neutral greeting', () {
      final line = GuardianSpeech.forEmotion(GuardianEmotion.welcome);
      expect(line.headline, 'Welcome back!');
      expect(line.text, isNotEmpty);
    });

    test(
      'idle and listening read for the attract screen when nobody is on',
      () {
        final idle = GuardianSpeech.forEmotion(GuardianEmotion.idle);
        expect(idle.text, contains('Student ID'));
        final listening = GuardianSpeech.forEmotion(GuardianEmotion.listening);
        expect(listening.text, contains('Student ID'));
      },
    );

    test('and switch to item prompts once a student is on', () {
      final idle = GuardianSpeech.forEmotion(
        GuardianEmotion.idle,
        firstName: 'Liam',
      );
      expect(idle.text, isNot(contains('Student ID')));
      expect(idle.text, contains('Liam'));
      final listening = GuardianSpeech.forEmotion(
        GuardianEmotion.listening,
        firstName: 'Liam',
      );
      expect(listening.text, contains('recycle'));
    });
  });
}

const Duration _tick = Duration(milliseconds: 50);
