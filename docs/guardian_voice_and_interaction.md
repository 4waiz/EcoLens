# Sprout: voice and interaction

How the Guardian talks and how it responds to being touched.

Two features, one design rule: **the Guardian is a character, not a widget.** It
never grows a button shape, never blocks the workflow, and never says anything
the screen is not already showing.

---

## 1. Guardian voice (text-to-speech)

### Architecture

```
GuardianDialogue          what Sprout is saying right now (text + identity)
      │                   lib/features/kiosk/application/guardian_dialogue.dart
      ├──────────────► speech bubble          (reads it)
      └──────────────► GuardianVoice          (speaks it)
                            │                 guardian_voice.dart
                            │   all policy: dedupe, mute, priority, replay
                            ▼
                       GuardianVoiceService   (abstract engine)
                            │                 guardian_voice_service.dart
                    ┌───────┴────────┐
                    ▼                ▼
        WebGuardianVoice      SilentGuardianVoice
     (browser speechSynthesis)   (no engine — silent, still safe)
```

The bubble and the voice read the **same** `GuardianDialogue`, so what is written
and what is heard can never drift apart.

### Supported platforms

| Target | Engine | Status |
|---|---|---|
| **Flutter Web** | the browser's own `speechSynthesis`, bound with `dart:js_interop` | **Speaking** |
| Android / iOS / Windows / test VM | `SilentGuardianVoice` | Silent, fully functional otherwise |

There is **no package dependency, no network call, no API key and no third-party
voice recording** anywhere in this path. The kiosk works offline and a school
firewall cannot mute the mascot.

**To give Android a voice**, add `flutter_tts` and return an implementation of
`GuardianVoiceService` from `guardian_voice_platform_stub.dart`. That is the only
file that changes — every rule below lives above the interface and is inherited
for free.

### Voice selection

`WebGuardianVoice` prefers a warm, youthful, clearly-articulated stock system
voice, in this order:

1. a name from `_preferredVoices` (Google UK English Female, Microsoft Libby /
   Sonia / Aria, Samantha, Karen, Tessa, Moira, Google US English);
2. any voice whose `lang` matches the configured language exactly;
3. any voice in the same language family (`en-*`);
4. the browser default.

No real person or child is imitated — these are the voices every browser already
ships. Chrome reports an empty voice list on the first call, so the list is
**re-resolved on each `speak` until it is populated**, rather than resolved once
at start-up and cached as null.

Tuning (`GuardianVoiceSettings`): `rate 0.97`, `pitch 1.16`, `volume 1.0`,
`en-GB`. Slightly slower than default so consonants survive a noisy corridor, and
only mildly raised in pitch — a squeaky voice is *harder* to understand, not
friendlier.

### Dialogue event rules

Every rule is enforced in `GuardianVoice` (pure Dart, no browser needed) and
covered by `test/unit/guardian_voice_test.dart`.

| Rule | Why |
|---|---|
| **One utterance per dialogue moment.** A repeated `GuardianSpeechEvent.id` is dropped. | Makes the whole feature rebuild-safe. The id is `<emotion>#<sequence>`, and `sequence` only increments on an *applied* expression change — so a widget rebuild is silent, while the same sentence arriving as a genuinely new moment (a second correct answer) speaks again. |
| **Never overlapping.** Every utterance cancels the previous one first. | On the web `speechSynthesis.speak` *queues* by default, so without this a busy kiosk builds a backlog of stale announcements and narrates them at an empty room. |
| **A bigger moment is not talked over.** A lower-priority line arriving while a higher-priority one is still speaking is dropped, not queued. | A level-up should finish. A routine "waiting for you" that arrives 300 ms later is no longer true by the time it would play. |
| **Mute is immediate and total.** Muting stops mid-sentence and blocks every new line. | It is the one control a teacher will reach for. |
| **Nothing is read back retroactively on un-mute.** | The moment has passed. |
| **A reset forgets the line.** | The next student is greeted out loud even if the words are identical. |

Spoken moments: waiting for a card, card detected, student welcome, waiting for
an item, item processing, correct portal, gentle retry, encouragement, mission
complete, level up, goodbye, and a tap reply.

**Not** spoken: on-screen statistics. The Guardian says its own line and nothing
else on the screen is narrated. A student's first name is spoken only where the
existing flow already greets them by it.

### Replay

A speaker button sits in the dialogue bubble. It:

* re-speaks the current line, bypassing the dedupe (asking again is a new
  request);
* respects mute — and is **hidden entirely** when the kiosk is muted or the
  device has no engine, because a control that cannot do anything is worse than
  no control;
* is at least **48 logical pixels**;
* is labelled `Hear that again`, and `Sprout is speaking. Hear that again` while
  a line is playing.

### Speaking feedback

Three small bars rise and fall beside Sprout's portrait in the bubble, and the
speaker icon switches to a waveform. The Guardian's face is **not** distorted to
fake a mouth — stretching the artwork reads as a rendering bug.

The indicator sits in a fixed-size box, so it appearing cannot reflow a single
word of the message.

### When TTS is unavailable or blocked

Nothing breaks, and nothing is thrown:

* **No engine** → `SilentGuardianVoice`. Written dialogue unchanged, replay
  control absent.
* **Browser autoplay policy** blocks the first line before any user gesture →
  the `onerror` handler treats it as normal, clears the speaking flag, and the
  next line (after the child has touched something) speaks.
* **`onend` never fires** — some browsers drop it when they silently decline —
  → a watchdog timer clears the speaking flag so the talking indicator can never
  stick on.
* Any synthesis exception is swallowed and, in debug builds only, printed.

### Lifecycle

`guardianVoiceBridgeProvider` is `autoDispose` and watched by `KioskChrome`, so
it lives exactly as long as the kiosk surface. Its teardown calls
`GuardianVoice.reset()` — which is what guarantees a sentence never carries on
playing over the next route.

---

## 2. Guardian interaction (tapping Sprout)

`lib/features/kiosk/application/guardian_interaction.dart`

Children **will** poke the dragon. This turns that into a designed moment.

### Motion only, never a change of expression

A tap plays a `GuardianTapMotion` (`jump`, `wave`, `spin`, `wiggle`, `flap`)
**layered over whatever expression is already on screen**. The artwork never
changes.

That is the whole design, and it removes a class of bug: a tap cannot contradict
the workflow, and when the wiggle ends there is nothing to restore — the emotion
never left. `test/widget/guardian_tap_test.dart` asserts the emotion *and* the
sequence number are untouched by a tap.

Every profile is bounded: 300–1200 ms, hop below 0.25 of the Guardian's height,
rotation below 1 radian. A mascot that spins on the spot stops looking like it
lives in the world.

### When a tap is welcome

Taps are accepted **only** in these calm states (`kGuardianTapStates`):

`idle` · `offline` · `waitingForCard` · `studentRecognised` · `readyToScan` ·
`classificationReady` · `waitingForStudentAnswer` · `houseLeaderboard` ·
`guardianEvolution`

Everything else — reading a card, capturing, analysing, processing, all three
feedback states, opening the slot, the reward summary, session end, maintenance
and errors — **ignores** the tap. Ignored, not queued: a cheer that arrives after
the moment has passed reads as a glitch.

Listing the *calm* states rather than the busy ones is deliberate. A kiosk state
added later defaults to refusing taps, which is the safe direction.

Moving into a critical state also **drops a reply already on screen**, so the
workflow line takes the bubble straight back.

### Cooldown

**1.9 seconds** (inside the 1.5–2.5 s window). Nine taps in one second produce
exactly one reaction; the other eight are counted as `ignored` and discarded.
`canTap` also drives the cursor and hover glow, so the Guardian only *looks*
touchable when it is.

### Lines

Two pools, so the Guardian never tells a logged-in student to tap the card they
are already holding, and never offers portal advice to an empty kiosk. Neither a
**line** nor a **motion** repeats back to back.

The reply expires after **2.8 s** on its own, which is what returns the bubble to
the workflow line without any screen having to remember to put it back. Its
bubble stays neutral cream/green — a friendly aside should not look like a
verdict on what the student just did.

### Discoverability and accessibility

* mouse cursor becomes a pointer, and only while a tap would be accepted;
* hover and focus **brighten the existing aura** — the Guardian never grows a
  border or a button shape;
* keyboard activation via <kbd>Enter</kbd>, <kbd>Space</kbd> and numpad Enter
  (`FocusableActionDetector` + `ActivateIntent`);
* semantics: `Sprout the Guardian. <expression>` with the hint
  `Activate to hear a tip.` (or `Busy right now.`);
* the tap is always *wired* — the controller, not the widget, decides whether it
  is welcome — so the Guardian stays focusable and announced even while the kiosk
  is busy.

### Reduced motion

Calm mode does not remove the interaction, it simplifies it:

| | Normal | Calm |
|---|---|---|
| Reaction | hop / spin / wiggle, up to 900 ms | a single 280 ms scale pulse |
| Rotation | yes | none |
| Leaf burst | yes | none |
| Reply text | yes | **yes** |
| Voice line | yes | **yes** |

A motion-sensitive student still gets a response. The feedback is never simply
deleted.

---

## Animation priority summary

From highest to lowest:

1. **Emotion** — owned by `GuardianController`, arbitrated by priority + minimum
   hold (`guardian_emotion.dart`). A celebration is never stomped on by a routine
   update.
2. **Expression entrance** — a short decaying hop played on every applied change,
   so a change of face reads as the character reacting.
3. **Tap reaction** — additive motion only, and only in a calm state.
4. **Ambient loop** — continuous breathing, bob and sway.

All four are composed in one `_buildStage` transform, inside a single
`RepaintBoundary`, driven by three controllers merged into one `AnimatedBuilder`.
Every tap term is enveloped so it starts and ends at exactly zero — which is what
lets a tap ride on top of a workflow expression without the character ever
settling in the wrong place.

---

## Tests

```bash
flutter test test/unit/guardian_voice_test.dart          # 22 — voice policy
flutter test test/unit/guardian_interaction_test.dart    # 15 — tap policy
flutter test test/widget/guardian_tap_test.dart          # 15 — wired into the kiosk
```
