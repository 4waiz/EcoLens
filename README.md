# EcoLens — Interactive Recycling Kiosk

> **Learn. Act. Earn. Save our planet.**

EcoLens is an AI-powered, gamified recycling system for schools and universities. It is installed on an **existing four-compartment recycling bin** (Plastic · Paper · Organic · General Waste) and turns every disposal into a short active-learning quiz — eliminating "wish-cycling" and teaching students how to recycle *right*.

This repository is a **complete, runnable Flutter MVP** implementing four connected experiences from a single codebase, backed by a fully working in-memory mock stack (no backend required to run the demo).

---

## ✋ Critical product rules (by design)

- **No student mobile app. No phones. Anywhere.** Students in school are not allowed phones, so the entire student experience lives on the **shared kiosk touchscreen** and students identify themselves **only with their physical Student ID card** (NFC/RFID). There is no phone login, phone camera, phone NFC, phone QR redemption, push notifications, or any `studentMobileApp` route.
- **EcoLens does not build hardware.** The client already owns the bin, the four compartments, the sliding/opening mechanism and the LED strips. EcoLens communicates with that **existing bin controller** through an abstract `HardwareBridgeService` and only sends *logical* commands (`openSlot`, `setSlotLed`, …). No actuators, motors, or fabrication are modelled.
- **Gamification rewards, never punishes.** Incorrect answers award 0 points and **never** subtract existing points. Weekends/holidays/approved absences never break a streak.

---

## The four experiences

| Experience | Route prefix | Who | Purpose |
|---|---|---|---|
| **Interactive Recycling Kiosk** | `/kiosk` | Students (shared device) | Tap ID card → scan item → quiz → feedback → rewards |
| **Teacher Dashboard** | `/teacher/*` | Teachers | Participation, accuracy, learning insights, reports |
| **Administrator Dashboard** | `/admin/*` | Admins | Students, cards, devices, rewards, gamification & AI rules |
| **Canteen Redemption Terminal** | `/canteen/*` | Canteen staff | Redeem rewards using the student's **physical ID card** |
| *(Developer / Hardware Simulator)* | `/dev` | Developers only | Drive the whole system with no physical hardware |

A **landing screen** (`/`) lets you jump into any experience during development. On a real deployment each device boots straight into one surface.

---

## Guardian Valley — the student-facing game world

The kiosk is not a dashboard. Every student-facing screen is staged inside
**Guardian Valley**, and an animated **Guardian** dragon guides the student
through it — reacting to what they actually do, in real time.

### Two renderers, one world

| Mode | When | What it is |
|---|---|---|
| `generatedArt` | default | Generated painted art, composited as five parallax plates. |
| `reducedMotion` | calm mode on | The same art, frozen on one frame. |
| `paintedFallback` | asset failure, or `--dart-define=ECOLENS_WORLD=painted` | The procedural Flutter world in `valley_painters.dart`, kept whole. |

`resolveWorldRenderMode` decides, in one place. If a generated layer fails to
decode the session degrades to the painted world permanently, logs a debug-only
diagnostic, and **shows a student nothing technical**. Neither renderer
duplicates a screen: the Guardian, HUD and panels are identical in both.

Layer order — the Guardian sits *inside* the world, so the foreground grass
draws over its feet:

```
base → clouds → water → particles → procedural motes → GUARDIAN → foreground → UI
```

The stone dais is painted into the base art. Because the plate is
`BoxFit.cover`-ed it lands somewhere different at every aspect ratio, so
`GuardianWorldStage` reproduces the cover transform and plants the Guardian's
feet on the dais wherever it ends up.

### The Guardian emotion system

Ten generated expression frames, driven by the real kiosk state machine:

`idle · listening · thinking · welcome · correct · tryAgain · encourage ·
celebrate · levelUp · goodbye`

- **Priorities and minimum holds** stop a celebration being erased by a routine
  state update landing in the same frame; lower-priority requests are *queued*,
  not dropped.
- **Transient** moments decay by themselves — to `idle` on the attract screen,
  `listening` mid-session.
- Every expression change plays a **small entrance hop**, so a change of face
  reads as the character reacting rather than a texture swap.
- Frames cross-fade in 240 ms inside a fixed box, so an expression change
  **cannot reflow the layout**.
- Fallback ladder: requested frame → `idle` frame → legacy PNG → vector painter.

Full reference: [docs/guardian_emotion_system.md](docs/guardian_emotion_system.md).

### Asset directory

| Path | Contents |
|---|---|
| `assets/backgrounds/` | Five valley plates (WebP, 1376 × 768). |
| `assets/guardian/` | Eleven Guardian expression frames (WebP, 1024²). |
| `art_source/` | Full-resolution masters. **Not bundled**, gitignored. |
| `tool/prepare_art_assets.py` | De-mattes the plates and transcodes to WebP. |

The generated overlays arrived with the transparency checkerboard baked into
RGB; the tool reconstructs a real alpha channel per plate. It also cut the
bundle from **15.4 MB to 2.4 MB**. See
[docs/ecolens_background_prompt.md](docs/ecolens_background_prompt.md).

### Accessibility

Three HUD controls, all of which change real behaviour and are covered by tests:

- **Sound** — mutes every Guardian cue. Cues are debounced twice so a rebuild
  can never make the kiosk chirp.
- **Calm mode** — freezes parallax, cloud drift, particles and the Guardian's
  continuous motion. Expression cross-fades remain, because they carry meaning,
  and success/failure stay readable through text and colour. Calm mode does
  **not** mute sound; they are separate needs.
- **Bigger text** — raises the whole game scale.

---

## Quick start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Freezed / json_serializable code (required after a clean checkout)
dart run build_runner build --delete-conflicting-outputs

# 3. Run it
flutter run -d chrome        # web (recommended for a quick look)
flutter run -d windows       # Windows desktop / kiosk
```

Then from the landing page choose an experience, **or** open a route directly:

- Kiosk: `http://localhost:<port>/#/kiosk`
- Teacher: `/#/teacher/login` · Admin: `/#/admin/login` · Canteen: `/#/canteen/login`
- Dev panel: `/#/dev`

> **Requires** Flutter **3.38+** / Dart **3.10+** (stable). Verified on Flutter 3.38.5.

### Run every mode

| Mode | Command |
|---|---|
| Web (Chrome) | `flutter run -d chrome` |
| Windows kiosk | `flutter run -d windows` |
| Linux kiosk | `flutter run -d linux` (enable Linux desktop first) |
| Production flavour | `flutter run --dart-define=ECOLENS_ENV=production` |

The kiosk is designed for a **landscape 1920 × 1200 (16:10)** touchscreen in full-screen kiosk mode.

---

## Demo accounts & demo student

All staff logins use the password **`ecolens`** and are **pre-filled** on each login screen — just press *Sign in*.

| Role | Identifier | Password |
|---|---|---|
| Teacher | `teacher@oakwood.edu` | `ecolens` |
| Administrator | `admin@oakwood.edu` | `ecolens` |
| Canteen staff | `EMP-1042` | `ecolens` |

**Primary demo student — Liam Carter**: Grade 4 · Class 4B · **Taurus** house · XP 120 · 15 Eco Points · streak 4 · Guardian stage *Sprout*.
The demo dataset also includes **12 students across all four houses** (Aries/Taurus/Leo/Aquarius), 20+ recycling sessions, 12 reward items, 4 kiosk devices, and audit history.

### Driving the kiosk in the demo

The kiosk waits for a physical card tap. To simulate one without hardware, open the **Developer / Hardware Simulator**:

1. From the landing page click **Developer / Hardware Simulator**, or long-press the **EcoLens logo** on the kiosk screen, or go to `/#/dev`.
2. Click **"Simulate Liam's card"** → Liam's profile loads on the kiosk.
3. Optionally force a specific item and confidence, then click **Open Kiosk** and walk the flow: *Scan My Item → Which bin? → feedback → Open slot → Reward summary*.

---

## Kiosk flow (state machine)

The kiosk is an explicit finite-state machine (`KioskState`) — invalid transitions are refused so the UI can never reach an impossible state.

```
idle → waitingForCard → readingCard → studentRecognised → readyToScan
     → capturingImage → analysingImage → classificationReady
     → waitingForStudentAnswer → processingAnswer
     → correctFeedback | incorrectFeedback | lowConfidenceFeedback
     → openingSlot → rewardSummary → sessionComplete → (clear session) → idle
```

Twelve kiosk screens are implemented: Idle/Attract, Reading Card, Student Recognised, Item Scanning, AI Analysis, Category Quiz, Correct, Incorrect, Low-Confidence, Reward Summary, House Leaderboard, and Guardian Evolution — plus Offline / Maintenance / Error states.

---

## Gamification rules (all admin-configurable)

Configured in **Admin → Gamification / AI Settings** and read everywhere from `GamificationConfig` (nothing is hardcoded in the UI):

- **+5 points** and **+5 XP** per correct cycle (configurable).
- Incorrect = **0 points**, never negative.
- **Daily cap 50 points** (configurable).
- **20-correct-in-a-row bonus** (configurable amount).
- **50 points = AED 1** conversion — configurable, and **monetary conversion can be disabled entirely** (schools can run non-monetary rewards only).
- **AI confidence threshold 80%** — below it, items route to **General Waste** with an honest "I'm not completely sure…" message.
- Streak policy is **weekend/holiday/approved-absence aware** with a configurable grace window.
- Non-monetary rewards supported: healthy-snack voucher, stationery, house privilege, sustainability raffle entry, avatar accessory, achievement badge.

The **Guardian** avatar evolves across five environmentally-symbolic stages that mirror real-world impact: **Seedling → Sprout → Eco Guardian → Forest Protector → Thriving Ecosystem Guardian** (all drawn procedurally with `CustomPainter` — no image assets required).

---

## Architecture

Layered and dependency-inverted: **UI → domain interfaces → data (mock/real)**. The UI and services depend only on domain contracts, so swapping mocks for real backends touches nothing above the data layer.

```
lib/
  app/            app.dart · app_bootstrap.dart · router.dart · providers.dart (DI graph)
  core/           constants · errors · theme · utils · widgets
  domain/         models (Freezed) · enums · repositories (interfaces) · services
  data/           mock (seed + in-memory DB) · datasources (mock + real adapters) · repositories
  features/
    kiosk/            application (state machine controller) · presentation (12 screens)
    teacher_dashboard/ admin_dashboard/ canteen_terminal/ · dev_panel/ · landing/
  shared/         components · layouts · responsive · painters (procedural art)
```

**Tech:** Flutter (Material 3), Riverpod (state), GoRouter (routing + role guards), Freezed + json_serializable (immutable models), fl_chart (dashboards), shared_preferences (local persistence), Dio / web_socket_channel (declared for real adapters).

Key patterns: repository pattern, feature-first structure, explicit FSM, pure domain services (`GamificationService` etc.), route guards by role, and environment flavours (`mock` / `demo` / `development` / `production`).

---

## Hardware integration points

EcoLens talks to the client's existing controller through **`HardwareBridgeService`** (`lib/domain/services/hardware_bridge_service.dart`). Logical commands only:

```dart
openSlot(WasteCategory.plastic)        setSlotLed(category, FeedbackColour.green)
clearSlotLeds()                         readNfcCard()  /  listenForStudentCard()
captureWasteImage()                     readWastePresenceSensor()  /  readBinFillLevel()
getControllerHealth()
```

- **MVP implementation:** `MockHardwareBridgeService` — a full in-memory simulation with LED state, fill levels, sensors, connection health, and fault injection for the dev panel.
- **Real integration seam:** `RealHardwareBridgeAdapter` (`lib/data/datasources/real_hardware_bridge_adapter.dart`) is a clearly-marked stub documenting how to wire **REST / WebSocket / local HTTP / serial / MQTT / platform-channel / vendor API**. Register it instead of the mock in `providers.dart` (`hardwareBridgeProvider`) for production — nothing else changes.

## AI integration points

Classification is behind **`AiClassificationService`** (`lib/domain/services/ai_classification_service.dart`).

- **MVP implementation:** `MockAiClassificationService` returns realistic results from a catalogue, honours dev overrides (forced item, forced confidence, forced error, offline fallback), and adds a small natural wobble.
- **Real integration seam:** `RealAiClassificationAdapter` (`lib/data/datasources/real_ai_classification_adapter.dart`) documents the suggested `POST /v1/classify` contract (returns category, object, confidence, condition, contamination, explanation, fact). The 80% threshold business rule lives in the **domain** (`WasteClassificationResult.routedCategory` + `GamificationService`), so the classifier only needs to return an honest confidence.

Register the real adapter in `providers.dart` (`aiClassificationProvider`) for production.

---

## Privacy & security

The kiosk is a **shared device**, so:

- Automatic student logout on a **configurable inactivity timeout** + a countdown on the finish screen.
- Student data and the **captured waste image are cleared** after processing / after the configured retention window (`SessionPrivacyService`).
- Student identifiers are **masked** on-screen (e.g. `•••• 0417`); full IDs are never shown on the kiosk or terminal.
- **Role-based routes** with GoRouter guards; mock token/session handling for teacher/admin/canteen.
- **Audit events** are recorded for administrator changes (config, cards, maintenance).
- No student data is written to debug logs, and **no previous student's details appear on the idle screen**.

## Offline behaviour

- Completed sessions are queued locally when offline (`SessionRepository.enqueueSession`).
- A non-intrusive **offline badge** shows the queue depth; reconnecting **flushes** the queue.
- **Idempotency keys** on sessions prevent duplicate reward transactions on sync.
- Hardware interaction stays local; AI can switch to a mock/local fallback; if classification is unavailable the flow degrades to a safe General-Waste/staff-assist path.

---

## Testing

```bash
flutter test                    # everything
flutter test test/unit          # domain/service unit tests
flutter test test/widget        # kiosk + dashboard + canteen widget tests
```

**Unit tests** cover: student-card auth, unknown-card handling, correct-category reward, incorrect = no points (never negative), daily cap, 20-cycle bonus, streak calculation, weekend/holiday streak handling, reward redemption + insufficient balance, session timeout & data clearing, invalid kiosk state transitions, hardware controller disconnection, offline session queue + idempotency, monetary-conversion configurability, and role-based route protection.

**Widget tests** cover: the idle screen (physical-card prompt + *no phone* assertion), the full kiosk flow (Liam card → recognised → scan → correct → rewards → session clears), incorrect-answer-no-points, low-confidence → General Waste, the canteen card scan, and the teacher overview.

**Guardian world tests** — `test/unit/guardian_emotion_test.dart`,
`test/widget/guardian_world_test.dart` and `test/widget/guardian_valley_test.dart`:

```bash
flutter test test/unit/guardian_emotion_test.dart    # emotion contract + policy
flutter test test/widget/guardian_world_test.dart    # render modes, a11y, overflow
```

- Every emotion maps to a distinct asset, declares a motion profile with a hop,
  and every transient emotion carries a positive hold.
- The FSM → emotion mapping is exhaustive over `KioskState`, escalates repeated
  mistakes to encouragement, and ranks `levelUp` above `celebrate`.
- A celebration survives the routine updates that follow it; queued requests
  apply when the hold expires; a session reset wipes the previous student.
- Generated-art, painted-fallback and failed-asset modes all render without
  overflow, and no technical error reaches a student.
- Calm mode stops both the Guardian and the world; bigger text stays
  overflow-free on all seven viewports.
- An expression change never resizes the Guardian (sampled mid-cross-fade).
- Rapid portal taps score exactly once.

They additionally assert:

- **Zero layout overflow** for the experience picker, the kiosk attract screen and the recognised-student screen at 1920×1200, 1920×1080, 1600×900, 1440×900, 1366×768, 1280×800 and 1024×768.
- The world, Guardian, dais and HUD render, and the HUD carries the school identity.
- The full student game profile (coins, level, streak, best, correct, oops, XP, score, daily progress, house rank) appears after a card read — and that **no personal data survives** `endSession()`.
- The impact panel's school-wide figures and the four waste-category world portals.
- Calm mode actually freezes ambient motion, and bigger text actually raises the game scale.

Verify static analysis with:

```bash
flutter analyze                 # expected: No issues found!
```

---

## Production deployment considerations

- **Kiosk lockdown:** run full-screen kiosk mode (Windows Assigned Access / a Linux kiosk session), disable OS gestures, hide the cursor, and disable the Escape-to-launcher shortcut used in dev. Boot straight to `/kiosk`.
- **Swap the mocks:** register `RealHardwareBridgeAdapter` and `RealAiClassificationAdapter` in `providers.dart`, and replace the mock repositories/`MockAuthService` with real backend-backed implementations. Set `--dart-define=ECOLENS_ENV=production` (this also disables the dev panel).
- **Secrets & config:** provide `ECOLENS_API_URL` / `ECOLENS_HW_URL` via `--dart-define`; never ship real credentials in the bundle.
- **Data & privacy:** move audit logs and sessions to a real store; confirm image-retention policy with the school; ensure student PII handling meets local regulations.
- **Observability:** add crash/analytics reporting and controller-health alerting (kiosks report `lastHeartbeat`).
- **Localisation:** the UI is structured for localisation and RTL (directional widgets throughout); add an Arabic ARB + locale to enable it without layout rewrites.
- **Accessibility:** high-contrast palette, large touch targets, semantics on interactive elements, and keyboard navigation on dashboards are already in place; validate with a screen reader on the target device.

---

## Assumptions

1. **No student mobile app** — every phone workflow was removed (school rule + the "scan ID card, not phone" update). Students use only their physical ID card + the touchscreen + the bin.
2. Kiosk targets Windows/Web at 1920×1200 landscape; verified on Chrome and Windows desktop.
3. Points defaults: 5/correct, 50/day cap, 50 pts = AED 1 — all admin-configurable, and monetary conversion can be disabled.
4. AI confidence threshold defaults to 80%; below it routes to General Waste.
5. Guardian stages extend the proposal's three tiers to five (Seedling → … → Thriving Ecosystem) per the screen spec.
6. Streak policy is weekend/holiday/approved-absence aware and never punishes.
7. All art (mascot, evolution stages, house emblems, ID card, logo) is drawn procedurally with `CustomPainter` — **no binary assets required**.
8. The four-slot layout maps metal cans into the Plastic/recycling slot (a common 4-bin school setup); this is data-driven and easy to change.
9. New-student creation reuses a default avatar id (avatar creation was out of scope); IDs are generated deterministically.
10. Mock services back every non-production environment; real integrations are left as clearly-marked adapters.

## Future enhancements

- Real vision model + on-device fallback; per-item recyclability rules per municipality.
- Real bin-controller adapter (vendor API / MQTT) with live LED + slot telemetry.
- Weekly Sustainability Raffle draw + house-privilege scheduling.
- Avatar accessory shop with equip/preview and more evolution branches.
- Backend + real auth (SSO for staff, card-provisioning workflow), multi-school tenancy.
- Deeper analytics (contamination heatmaps, cohort comparisons, export to CSV/PDF for real).
- Arabic localisation and full RTL pass.

---

*Built as an MVP: the complete mock/demo flow works end-to-end across all four experiences. Real AI and physical-hardware integrations are intentionally left as documented adapter seams.*
