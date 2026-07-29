# EcoLens — Guardian Valley background art brief

This document is the complete, self-contained image-generation prompt for the
**Guardian Valley** kiosk background, plus the exact steps to drop the result
into the Flutter app.

## Why this file exists

The EcoLens kiosk **must not depend on an online image-generation service at
runtime**. The valley therefore ships as a procedural Flutter scene
(`lib/shared/painters/valley_painters.dart` + `lib/shared/components/guardian_valley.dart`)
that renders offline, at any resolution, with animated clouds, waterfalls,
swaying trees, drifting leaves and fireflies.

If a school later wants bespoke painted art, generate it with the prompt below
and hand it to the same widget — the procedural scene stays as the guaranteed
fallback.

---

## Primary prompt (16:9 landscape)

```
A bright, enchanted eco-forest valley in a friendly 2D animated-game style,
painted for a children's educational game. Wide 16:9 landscape.

Composition:
- A wide open grassy meadow in the foreground with a clear, uncluttered circular
  clearing in the exact centre — a mossy stone platform where a character will
  stand. Leave the centre third of the image visually calm and simple.
- Rolling green hills and soft, hazy blue-green mountains in the far distance
  with gentle atmospheric perspective.
- Two tall rocky cliffs, one on the left third and one on the right third, each
  with a bright turquoise waterfall tumbling into a small misty pool.
- A shallow winding stream crossing the middle ground from left to right.
- Layered forest bands between the mountains and the meadow: distant conifer
  silhouettes fading into haze, then fuller round-canopy trees.
- Two large framing trees at the far left and far right edges, their canopies
  hanging in from the top corners to frame the scene, with a few soft vines.
- Wildflowers, grass tufts, mushrooms, ferns and a few smooth boulders scattered
  through the meadow, denser at the edges and sparse in the centre.
- Subtle recycling-inspired nature details: leaves arranged in a soft triangular
  loop motif on the stone platform rim, glowing green rune-like sprouts.

Lighting and mood:
- Friendly mid-morning daylight, warm sun high on the upper right with a soft
  golden bloom and gentle god rays through the canopy.
- Bright, saturated but soft palette: fresh spring greens, sky blue, turquoise
  water, warm sandstone, cream highlights.
- Soft depth of field on the far mountains; crisp foreground.
- Cheerful, safe, magical, welcoming — absolutely nothing dark, spooky,
  threatening or aggressive.

Style:
- Modern 2D animated feature-film background painting / high-quality mobile game
  art. Clean shapes, smooth gradients, soft painterly texture, subtle outlines.
- Child-friendly, ages 6–12.

Hard constraints:
- NO text, letters, numbers, logos or watermarks anywhere in the image.
- NO characters, creatures, people or animals.
- NO copyrighted or trademarked characters, styles or properties.
- NO buildings, vehicles, roads, signage, litter or bins.
- NO dark, scary, night-time or post-apocalyptic elements.
- The upper-left, upper-right and lower-centre areas must stay visually quiet so
  UI panels remain readable on top.
```

### Negative prompt

```
text, watermark, signature, logo, letters, numbers, ui, hud, interface,
characters, people, animals, creatures, dragon, mascot, buildings, houses,
vehicles, roads, fences, bins, litter, trash, dark, night, gloomy, scary,
horror, dystopian, smoke, fire, photorealistic, 3d render, low quality, blurry,
jpeg artifacts, busy centre, cluttered composition
```

### Recommended output settings

| Setting          | Value                                                        |
| ---------------- | ------------------------------------------------------------ |
| Aspect ratio     | 16:9 (also export 16:10 for 1920×1200 kiosks)                |
| Resolution       | 3840 × 2160 master, downscale to 2560 × 1440 for shipping     |
| Format           | PNG master → WebP or optimised PNG for the app (target < 900 KB) |
| Colour profile   | sRGB                                                          |

### Companion prompts (optional layers)

If you want true parallax from bitmaps rather than the procedural layers, ask
for the same scene split into three **transparent PNG** layers:

1. `valley_sky.png` — sky, sun, clouds, distant mountains, waterfalls. Opaque.
2. `valley_forest.png` — mid-ground tree bands only, transparent above/below.
3. `valley_meadow.png` — foreground meadow, stream, flowers and the two framing
   trees, transparent above the horizon line.

Keep the horizon at **58 % from the top** in every layer so they register.

---

## Dropping generated art into the app

1. Save the file as `assets/images/valley_background.png` (already covered by the
   `assets/images/` entry in `pubspec.yaml` — no pubspec change needed).
2. Pass it to the world widget. The only change required is in
   `lib/features/kiosk/presentation/widgets/kiosk_chrome.dart`:

   ```dart
   GuardianValley(
     animate: !prefs.reduceMotion,
     backgroundImage: const AssetImage('assets/images/valley_background.png'),
     child: ...,
   )
   ```

3. That replaces the procedural sky/forest/meadow layers only. The drifting
   leaves and fireflies, the glowing stone dais under the Guardian and every HUD
   panel keep working unchanged, and `GuardianValley` automatically falls back to
   the procedural scene if the asset fails to decode.

---

## The Guardian character asset

The Guardian dragon ships as `assets/images/guardian_dragon.png`.

- Source: the supplied `bABY.png`, which already carried a real alpha channel
  (fully transparent corners, 105 distinct alpha levels — image viewers with a
  dark backdrop just make it *look* like a black background).
- Processing: transparent margins trimmed to the artwork bounding box
  (414 × 500 → 397 × 491) and re-encoded losslessly with metadata stripped
  (406 KB → 282 KB). **No** resampling, stretching, cropping of the character, or
  quality loss.
- Rendering: `BoxFit.contain` at `FilterQuality.high`, so the aspect ratio is
  always preserved. See `lib/shared/components/guardian_dragon.dart`.
- `Baby.jpg` (220 × 229, white background, JPEG artifacts) is intentionally **not**
  shipped: it is far lower resolution than the primary asset and its white
  background has no place in the game interface. The vector
  `GuardianAvatar` painter is used as the runtime fallback instead, so the kiosk
  always has a Guardian on screen even if the PNG cannot be decoded.

### If you regenerate the Guardian

```
A cute friendly baby dragon mascot for a children's recycling game, full body,
standing, facing the viewer, big warm eyes, small wings, soft rounded shapes,
fresh green and gold scales with leaf-shaped crest, cheerful smile, gentle and
approachable, 2D animated-game character art, clean outlines, soft shading,
centred, full transparent background, no shadow baked in, no text, no logo.
```

Export at 1200 px tall or more, transparent PNG, then trim the empty margin and
save to `assets/images/guardian_dragon.png`.

---

## Palette reference (keep generated art in this range)

| Role              | Hex       |
| ----------------- | --------- |
| Sky top           | `#5BB8E8` |
| Sky horizon       | `#DDF3E4` |
| Sun bloom         | `#FFF0B8` |
| Far peaks (hazy)  | `#A9CEDC` |
| Cliff rock        | `#C2A985` |
| Waterfall         | `#B9E2F5` → `#F2FBFF` |
| Far forest        | `#6FA97F` |
| Near forest       | `#3C7749` |
| Meadow            | `#8FC96C` → `#5EA347` |
| Stone dais        | `#CEC3A4` |
| Eco-rune glow     | `#8BE08F` |
| EcoLens primary   | `#2E7D46` |

These are the exact constants in `ValleyPalette`
(`lib/shared/painters/valley_painters.dart`), so bitmap art generated to this
palette will sit seamlessly next to the procedural layers.

---

# Part 2 — The generated art actually shipped

The procedural valley described above is now the **fallback**. The kiosk ships
generated painted art as its preferred renderer. This section documents what was
integrated and how to replace it.

## Files

Bundled (`assets/`, listed in `pubspec.yaml`):

| Asset | Size | Notes |
|---|---|---|
| `backgrounds/guardian_valley_base.webp` | 212 KB | Opaque. The valley itself. |
| `backgrounds/guardian_valley_clouds.webp` | 114 KB | Transparent. Pure white clouds. |
| `backgrounds/guardian_valley_water.webp` | 104 KB | Transparent. Stream shimmer, fade baked in. |
| `backgrounds/guardian_valley_particles.webp` | 89 KB | Transparent. Soft light and dust. |
| `backgrounds/guardian_valley_foreground.webp` | 74 KB | Transparent. Grass and flowers. |
| `guardian/guardian_<emotion>.webp` × 11 | ~110 KB each | Transparent, 1024². |

All plates are normalised to **1376 × 768**. Masters live in `art_source/`
(gitignored, not bundled) and are never modified in place.

**15.4 MB of PNG → 2.4 MB of WebP (84 % smaller.)**

## The de-matte step — read this before regenerating

The four overlay plates arrived with the **transparency checkerboard baked into
RGB**. Alpha was 255 everywhere; the "transparent" regions were literally
painted grey checks. Stacking them as-is paints a grey grid over the valley.

`tool/prepare_art_assets.py` reconstructs a real alpha channel. It handles three
cases, because the plates were not exported consistently:

| Plate | Matte greys | Mode | Why |
|---|---|---|---|
| clouds | ~62 / 114 | `white` | Clouds are pure white drawn at *partial opacity*. `observed = a·255 + (1−a)·checker` solves exactly. Treating them as solid art turned semi-transparent clouds into grey discs. |
| foreground | ~128 / 174 | `gated` | Solid art with crisp edges. Only checker reachable from the image border is cleared, so grey *inside* the art stays opaque. |
| water, particles | ~128 / 174 | `chroma` | Their gaps are enclosed by the art, so a border flood-fill cannot reach them. The matte is pure grey (measured chroma ≈ 0.5) and the art is not (≈ 32), so saturation separates them. |

Two details that are easy to get wrong:

- the checker was **resampled** before export, so its cell edges ring a few
  levels past the flat greys. Without an alpha floor that ringing survives as a
  ~20 %-opaque grid over the whole layer;
- for a purely diffuse plate (particles) alpha must be derived from the
  *smoothed* image too, or the checker's own faint chroma survives in the alpha.

**If you regenerate the art, export with real transparency and this whole step
becomes unnecessary** — set the plate's mode to `gated` with `feather=0`, or
bypass `dematte()` entirely.

## Layer order and motion

```
base  →  clouds  →  water  →  particles  →  procedural motes  →  GUARDIAN  →  foreground  →  UI
```

The Guardian sits **between the particle sheet and the foreground**, so the
foreground grass draws over its feet. That is what sells the depth.

| Layer | Parallax | Motion |
|---|---|---|
| base | 2 px | still |
| clouds | 9 px | 92 s horizontal loop + 6 px vertical wander |
| water | 5 px | 26 s horizontal loop |
| particles | 6 px | still (the animated motes above it move) |
| foreground | 12 px | still, `IgnorePointer` |

Parallax follows the pointer on desktop/web and drifts on a slow lissajous where
there is no pointer. No gyroscope, no phone sensors. All of it freezes in
reduced-motion mode.

**Scrolling plates are drawn as three copies — `A | mirrored B | A` — scrolled
across two viewport widths.** These are paintings, not tiles: butting two copies
together shows a seam, and mirroring makes both joins match column-for-column
while the wrap lands on identical pixels. They also must *not* use the parallax
bleed the still plates use, or adjacent copies overlap and composite the artwork
twice, printing a bright vertical band down the sky.

## Standing the Guardian on the dais

The dais is painted into the base plate at normalised `(0.498, 0.688)`, width
`0.204`. Because the plate is `BoxFit.cover`-ed, that lands somewhere different
at every aspect ratio, so `GuardianWorldStage` reproduces the cover transform and
plants the Guardian's feet wherever the dais actually ends up. Guardian height is
`0.47 ×` the rendered plate height, chosen so its stance covers ~85 % of the dais.

If you regenerate the base with the dais somewhere else, update `daisAnchor`,
`daisWidth` and `guardianHeightFactor` in `guardian_world_assets.dart` — nothing
else needs to change.

## Replacing a layer

1. Put the new PNG in `art_source/backgrounds/` under the same name.
2. `python tool/prepare_art_assets.py`
3. If it exported with real transparency, set its mode to `gated`/`feather=0`.

## Falling back to the painted world

`resolveWorldRenderMode` picks the renderer:

- any generated layer failing to decode → **painted fallback**, permanently for
  that session, with a debug-only log and nothing technical shown to a student;
- `--dart-define=ECOLENS_WORLD=painted` → painted fallback always (weak hardware,
  or a build shipped without the art);
- calm mode → generated art frozen on one frame;
- otherwise → generated art.

The procedural world in `valley_painters.dart` is **kept whole** and is exercised
by tests in both modes.

## Known limitation

The base plate carries a faint ~80 px sky texture from the generator itself
(measured: 362 in the master, 365 after transcode — the pipeline adds 0.7 %).
It is inherent to the source art, not to the processing.
