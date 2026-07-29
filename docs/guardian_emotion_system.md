# The EcoLens Guardian emotion system

The Guardian is a character, not a decoration. It reacts to what the student
actually does, using ten hand-generated expression frames plus procedural motion
around them.

Everything here lives under `lib/shared/world/` (the character) and
`lib/features/kiosk/application/` (the mapping from the kiosk).

---

## The emotions

| Emotion | Asset | Meaning | Priority | Min hold | Transient |
|---|---|---|---|---|---|
| `idle` | `guardian_idle.webp` | Resting. Everything decays back here. | 0 | — | no |
| `listening` | `guardian_listening.webp` | Waiting on the student. | 1 | — | no |
| `thinking` | `guardian_thinking.webp` | Working (card read, classification). | 1 | — | no |
| `welcome` | `guardian_welcome.webp` | A student was just recognised. | 2 | 900 ms | yes |
| `correct` | `guardian_correct.webp` | Sorted correctly. | 3 | 900 ms | yes |
| `tryAgain` | `guardian_try_again.webp` | A first slip. Never a harsh error. | 3 | 800 ms | yes |
| `encourage` | `guardian_encourage.webp` | Repeated slips — support, not correction. | 3 | 800 ms | yes |
| `goodbye` | `guardian_goodbye.webp` | The session is ending. | 4 | 1400 ms | no |
| `celebrate` | `guardian_celebrate.webp` | A mission or daily goal is complete. | 5 | 1600 ms | yes |
| `levelUp` | `guardian_level_up.webp` | A new Guardian level. | 5 | 1600 ms | yes |

Assets are resolved by `GuardianEmotionX.assetPath`. **No screen ever names an
asset file.**

---

## Transition rules

Kiosk state arrives in bursts — several providers can settle in the same frame.
Without arbitration a celebration would be erased by a routine "back to idle" a
few milliseconds later. `GuardianController` therefore applies:

1. **Priority.** A higher-priority emotion interrupts immediately.
2. **Minimum hold.** While an emotion is inside its hold, equal-or-lower
   priority requests are **queued, not dropped**, and applied when it expires.
3. **Transient decay.** Moments (a cheer, a nudge) fall back on their own.
4. **Resting state.** They fall back to whatever the *kiosk* considers resting —
   `idle` on the attract screen, `listening` mid-session. Set by
   `GuardianDirector.restingFor`. Without this a logged-in student would be told
   to tap the card they had just tapped.
5. **Replay.** Re-requesting the same emotion *outside* its hold replays it (a
   second correct answer should visibly cheer again). Inside the hold it is a
   no-op. Widgets key their animation off `GuardianState.sequence`, not the
   emotion, so replays work.

Holds are deliberately short. A kiosk that makes a child wait for an animation
is a kiosk that makes a queue.

---

## Event → emotion mapping

Defined in `GuardianDirector.emotionFor` (pure, fully unit-tested).

| Kiosk state | Emotion |
|---|---|
| `idle`, `offline` | `idle` |
| `waitingForCard` | `listening` |
| `readingCard` | `thinking` (+ `cardDetected` cue) |
| `studentNotFound` | `tryAgain` |
| `studentRecognised` | `welcome` |
| `readyToScan` | `listening` |
| `capturingImage`, `analysingImage` | `thinking` |
| `classificationReady`, `waitingForStudentAnswer` | `listening` |
| `processingAnswer` | `thinking` |
| `correctFeedback`, `lowConfidenceFeedback` | `levelUp` if the stage changed → `celebrate` if a bonus applied → else `correct` |
| `incorrectFeedback` | `tryAgain` on the first slip, `encourage` from the second |
| `openingSlot`, `waitingForWasteDrop`, `rewardSummary` | `levelUp` / `celebrate` if earned, else `idle` |
| `sessionComplete` | `goodbye` |
| `houseLeaderboard` | `idle` |
| `guardianEvolution` | `welcome` |
| `maintenance`, `error` | `tryAgain` — calm wording, never an alarm |

The director also remembers the **consecutive wrong-answer streak**, and whether
this session has already celebrated or levelled up (so neither fires twice).
Returning to an empty `idle` wipes all of it — no trace of the previous student
survives.

---

## Micro-animations

Every expression change plays a **small entrance hop**, so a change of face
reads as the character doing something rather than a texture swap. Defined per
emotion in `GuardianMotionProfile`:

| Emotion | Hop height | Hops | Extras |
|---|---|---|---|
| `idle` | 2 % | 1 | slow breathing, 3.2 s loop |
| `listening` | 2.8 % | 1 | attentive head tilt |
| `thinking` | 2.2 % | 1 | slow alternating tilt, cool aura |
| `welcome` | 7 % | 2 | wave-like rock, green aura |
| `correct` | 8.5 % | 2 | leaf burst, green aura |
| `tryAgain` | 3 % | 1 | gentle side-to-side rock — never a harsh shake |
| `encourage` | 4.5 % | 1 | warm forward pulse |
| `celebrate` | 15 % | 3 | rotation, leaf burst, gold aura |
| `levelUp` | 12 % | 2 | radial glow, leaf burst |
| `goodbye` | 4 % | 1 | slow wave |

Hop heights are fractions of the Guardian's rendered height, and each hop in a
series decays. The contact shadow tightens as the character leaves the ground.

The cross-fade between frames is **240 ms** with a 0.97 → 1.0 settle. Both
frames are stacked inside a fixed `SizedBox`, so an expression change **cannot
reflow the scene** — asserted by a test that samples mid-transition.

---

## Alignment correction

The ten frames share a 1024² transparent canvas. They were measured, not
trusted: the **head centroid** (the anchor the eye actually tracks) sits within
**1.1 % of canvas width** across the whole set, and feet within 0.6 % of height.

Only three frames drift enough to read as a jump during a cross-fade:

| Emotion | dx | dy |
|---|---|---|
| `celebrate` | +0.0042 | −0.0059 |
| `levelUp` | +0.0042 | −0.0039 |
| `goodbye` | +0.0107 | −0.0039 |

Everything else uses `GuardianEmotionLayout.neutral`. Values are fractions of
the rendered box and are applied as a translation — **the character is never
cropped or scaled to fit**.

To re-measure after replacing artwork:

```bash
python - <<'EOF'
from PIL import Image
import numpy as np, glob, os
for f in sorted(glob.glob('assets/guardian/*.webp')):
    im = Image.open(f).convert('RGBA'); a = np.asarray(im)[..., 3] / 255.0
    w, h = im.size
    ys, _ = np.nonzero(a > 0.35); y0, y1 = ys.min(), ys.max(); H = y1 - y0
    band = a[y0:int(y0 + H * 0.28), :]
    cx = (band.sum(0) * np.arange(w)).sum() / band.sum() / w
    print(f'{os.path.basename(f):<26} headCx={cx:.4f} feetY={y1/h:.4f}')
EOF
```

Compare each to `guardian_idle` and add a correction only where the difference
exceeds ~0.005.

---

## Fallback ladder

`GuardianMascot` degrades in this order, and never shows a student an error:

1. the requested emotion frame;
2. `guardian_idle.webp`;
3. the legacy `assets/images/guardian_dragon.png`;
4. the vector `GuardianAvatar` painter.

Frames that fail are recorded in a static set and **never retried**, so a
missing file cannot spin the widget in a rebuild loop. While a frame decodes the
slot is left empty rather than flashing the retired vector mascot — frames are
precached, so that gap is a frame or two at most.

---

## Reduced motion

`animate: false` (driven by the kiosk's calm-mode toggle):

- expression **cross-fades still happen** — they carry meaning;
- the continuous breathe/bob/sway loop stops;
- entrance hops, rotation and sparkle bursts are skipped;
- background parallax and drift freeze (see `GuardianWorldRenderMode.reducedMotion`).

Success and failure remain communicated through **text and colour**, so nothing
depends on movement. Reduced motion does **not** imply muted sound — they are
separate needs and separate toggles.

---

## Sound

`GuardianEmotionX.soundCue` maps emotions to abstract `GuardianSoundCue`s, which
`GuardianAudio` plays via platform system sounds and haptics. EcoLens ships no
audio files — adding any would mean shipping third-party recordings — so the
cues are deliberately conservative, work on every target, and need no licensing.
Swapping in real audio later means changing only `GuardianAudio._emit`.

Cues are debounced twice (controller, then player), so a rebuild or a
double-settle can never make the kiosk chirp twice. A muted kiosk is silent; a
missing platform channel is swallowed.

---

## Adding a new emotion

1. Add the value to `GuardianEmotion`.
2. Add `guardian_<stem>.png` to `art_source/guardian/` and run
   `python tool/prepare_art_assets.py`.
3. Extend `_fileStem`, `priority`, `minimumHold`, `isTransient`, `motion` and
   (if it should make a noise) `soundCue`.
4. Add a line to `GuardianSpeech.forEmotion` — the `switch` is exhaustive, so
   the compiler will tell you.
5. Map at least one kiosk state to it in `GuardianDirector.emotionFor`.
6. Measure alignment (above) and add a correction only if needed.

`test/unit/guardian_emotion_test.dart` will fail if you miss the asset, the
motion profile, the speech line, or give a transient emotion a zero hold.

## Replacing an emotion image

Drop the new PNG into `art_source/guardian/` under the same name, re-run the
pipeline, re-measure alignment. No Dart changes are needed.
