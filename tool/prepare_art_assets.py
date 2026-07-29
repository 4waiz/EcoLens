#!/usr/bin/env python3
"""Prepare the generated Guardian Valley art for shipping in the Flutter app.

Two jobs:

1. **De-matte the background overlay layers.** The generated cloud / water /
   particle / foreground layers arrived with the transparency *checkerboard
   baked into RGB* (alpha was 255 everywhere), so stacking them would paint a
   grey checker over the valley. This script reconstructs a real alpha channel.

2. **Transcode to WebP.** 15 MB of PNG is far too heavy for a school tablet's
   web bundle. WebP keeps alpha and cuts that by roughly 90%.

Originals are never modified in place — they are copied to `art_source/` first.

Usage:  python tool/prepare_art_assets.py
"""

from __future__ import annotations

import os
import shutil

import numpy as np
from PIL import Image
from scipy import ndimage

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_BG = os.path.join(REPO, "assets", "backgrounds")
SRC_GUARDIAN = os.path.join(REPO, "assets", "guardian")
ARCHIVE = os.path.join(REPO, "art_source")

def detect_checker(rgb: np.ndarray) -> tuple[float, float]:
    """Find the two flat greys of the baked checkerboard.

    The layers did not all use the same matte — the cloud layer shipped a dark
    checker (~64/112) while the rest used the familiar mid greys (~128/174) —
    so the band is measured per file from a border strip rather than assumed.
    """
    h, w, _ = rgb.shape
    band = np.concatenate(
        [
            rgb[:8].reshape(-1, 3),
            rgb[-8:].reshape(-1, 3),
            rgb[:, :8].reshape(-1, 3),
            rgb[:, -8:].reshape(-1, 3),
        ]
    )
    chroma = band.max(1) - band.min(1)
    luma = band.mean(1)[chroma <= 6]
    if luma.size < band.shape[0] * 0.05:
        return 128.0, 174.0  # not enough matte visible; fall back to defaults
    hist, edges = np.histogram(luma, bins=64, range=(0, 256))
    centres = (edges[:-1] + edges[1:]) / 2
    keep = centres[hist > luma.size * 0.03]
    if keep.size < 2:
        return 128.0, 174.0
    return float(keep.min()) - 4.0, float(keep.max()) + 4.0

# Per-layer de-matte tuning.
#   feather  – how far the soft-edge band extends past the flat checker (px)
#   soft     – threshold controlling how quickly alpha ramps up off the checker
#   gated    – True  : only the border-connected checker region becomes
#                      transparent (right for solid art with crisp edges)
#              False : alpha is derived everywhere (right for diffuse glows,
#                      which are soft across their whole extent)
#   mode  – "gated": solid art with crisp edges. Only checker reachable from
#                    the image border is cleared, so grey *inside* the art
#                    (cloud shading, stone) stays opaque.
#           "chroma": art whose gaps are enclosed by the art itself, where a
#                    border flood-fill cannot reach them. The checker is pure
#                    grey and this content is not, so alpha is driven by
#                    saturation plus a highlight term instead.
#   fmt   – output container. "webp" everywhere except the clouds, whose picture
#           lives almost entirely in the ALPHA channel (pure white drawn at
#           partial opacity). WebP compresses alpha lossily and separately, and
#           the artefacts showed up as faint blocking in the soft cloud edges
#           against a flat sky — on the one plate that scrolls continuously.
#           PNG is lossless there and worth the extra ~140 KB.
#           Do not switch the clouds back to WebP.
LAYERS = {
    "guardian_valley_clouds": dict(mode="white", smooth=13, fmt="png"),
    # The generated ripples span far more of the plate than the stream
    # actually occupies in the base art, and clipping them at runtime left a
    # hard horizontal edge across the meadow. Baking the fade into the alpha
    # confines them to the stream for free — no runtime mask, no saveLayer.
    "guardian_valley_water": dict(
        mode="chroma",
        chroma_soft=48.0,
        high_soft=58.0,
        smooth=21,
        vfade=(0.575, 0.640, 0.700, 0.745),
    ),
    # The particle sheet is taken as a soft light layer only: its crisp leaves
    # are dropped because the app already animates its own leaves and pollen,
    # and frozen ones sitting beside moving ones read as a rendering bug.
    "guardian_valley_particles": dict(
        mode="chroma", chroma_soft=70.0, high_soft=85.0, smooth=29, cutoff=0.16, smooth_alpha=True
    ),
    "guardian_valley_foreground": dict(mode="gated", feather=4, soft=26.0),
}

# Every layer is normalised to this so the layers register exactly on top of
# each other (the water layer shipped 32px wider than the rest).
CANVAS = (1376, 768)

# Alpha below this is treated as checker ringing rather than real artwork.
FLOOR = 0.24


def source_png(kind: str, name: str) -> str:
    """Master PNG for `name`.

    Prefers the archive, so the script stays re-runnable after the working
    PNGs have been removed from the shipped bundle.
    """
    archived = os.path.join(ARCHIVE, kind, name)
    if os.path.exists(archived):
        return archived
    return os.path.join(REPO, "assets", kind, name)


def archive_originals() -> None:
    for src in (SRC_BG, SRC_GUARDIAN):
        dest = os.path.join(ARCHIVE, os.path.basename(src))
        os.makedirs(dest, exist_ok=True)
        for name in sorted(os.listdir(src)):
            if not name.lower().endswith(".png"):
                continue
            target = os.path.join(dest, name)
            if not os.path.exists(target):
                shutil.copy2(os.path.join(src, name), target)
    print(f"originals archived to {os.path.relpath(ARCHIVE, REPO)}/")


def dematte(
    path: str,
    mode: str,
    feather: int = 4,
    soft: float = 26.0,
    chroma_soft: float = 13.0,
    high_soft: float = 42.0,
    smooth: int = 0,
    cutoff: float = 0.10,
    smooth_alpha: bool = False,
    vfade: tuple[float, float, float, float] | None = None,
) -> Image.Image:
    """Recover a real alpha channel from a baked transparency checkerboard."""
    rgb = np.asarray(Image.open(path).convert("RGB"), dtype=np.float32)
    checker_lo, checker_hi = detect_checker(rgb)
    checker_mid = (checker_lo + checker_hi) / 2.0
    print(f"    mode={mode} checker greys ~{checker_lo + 4:.0f}/{checker_hi - 4:.0f}")

    # Colour is recovered from a checker-free version of the plate. Averaging
    # over one checker period collapses the two greys to their mean, which is
    # exactly the constant the un-matte below assumes. Alpha still comes from
    # the *raw* plate so crisp shapes keep crisp edges.
    colour = (
        ndimage.uniform_filter(rgb, size=(smooth, smooth, 1)) if smooth > 0 else rgb
    )

    # Alpha normally comes from the RAW plate so crisp shapes keep crisp edges.
    # For a purely diffuse layer that is wrong: the checker's own faint chroma
    # survives as a grid in the alpha, which is visible against flat sky. There,
    # derive alpha from the smoothed plate as well.
    source = colour if smooth_alpha else rgb
    chroma = source.max(axis=2) - source.min(axis=2)
    luma = source.mean(axis=2)

    if mode == "white":
        # The cloud plate is pure white art drawn at partial opacity over the
        # matte, so `observed = a*255 + (1-a)*checker` can be solved exactly
        # once the checker has been averaged away. Treating it like solid art
        # instead is what turned semi-transparent clouds into grey discs.
        smoothed = colour.mean(axis=2)
        alpha = np.clip((smoothed - checker_mid) / (255.0 - checker_mid), 0.0, 1.0)
        alpha = np.where(alpha < 0.03, 0.0, alpha)
        out = np.dstack(
            [
                np.full_like(alpha, 255.0),
                np.full_like(alpha, 255.0),
                np.full_like(alpha, 255.0),
                alpha * 255.0,
            ]
        ).astype(np.uint8)
        img = Image.fromarray(out, "RGBA")
        return img if img.size == CANVAS else img.resize(CANVAS, Image.LANCZOS)

    if mode == "chroma":
        # The matte is pure grey (measured chroma ~0.5); this artwork is not
        # (measured chroma ~32). Saturation alone separates them cleanly, and a
        # highlight term catches white spray and sparkle.
        alpha = np.clip(
            np.maximum(chroma / chroma_soft, (luma - checker_hi) / high_soft),
            0.0,
            1.0,
        )
        # No ringing floor is needed here: the checker contributes no chroma.
        alpha = np.where(alpha < cutoff, 0.0, alpha)
    else:
        luma_dev = np.maximum(0.0, np.maximum(checker_lo - luma, luma - checker_hi))
        alpha = np.clip(np.sqrt(chroma**2 + luma_dev**2) / soft, 0.0, 1.0)
        # The checker was resampled before export, so its cell edges ring a few
        # levels past the flat greys. Without a floor that ringing survives as
        # a ~20%-opaque grid over the whole layer.
        alpha = np.clip((alpha - FLOOR) / (1.0 - FLOOR), 0.0, 1.0)

    if mode == "gated":
        # Anything enclosed by artwork stays opaque even if it happens to be a
        # flat grey (cloud shading, stone, shadow). Only checker that is
        # reachable from the image border is genuinely "outside".
        is_checker = (
            (chroma <= 12) & (luma >= checker_lo - 14) & (luma <= checker_hi + 14)
        )
        labels, count = ndimage.label(is_checker)
        border = set(labels[0, :]) | set(labels[-1, :])
        border |= set(labels[:, 0]) | set(labels[:, -1])
        border.discard(0)
        bg = np.isin(labels, list(border)) if border else np.zeros_like(is_checker)
        # Deep inside the empty region nothing can be artwork: hard-zero it.
        # Only the rim next to real art keeps its recovered soft alpha.
        core = ndimage.binary_erosion(bg, iterations=max(1, feather))
        rim = ndimage.binary_dilation(bg, iterations=feather) & ~core
        alpha = np.where(core, 0.0, np.where(rim, alpha, 1.0))
        print(f"    checker components={count} border-connected={len(border)}")

    # Un-matte the colour: observed = a*F + (1-a)*checker  ->  solve for F.
    a3 = alpha[..., None]
    # Dividing by a very small alpha amplifies the residual checker enormously,
    # which is what printed a faint grid across the glow layers. Clamp the
    # divisor: faint pixels stay slightly desaturated instead of exploding.
    floor_div = 0.35 if mode == "chroma" else 1e-4
    with np.errstate(divide="ignore", invalid="ignore"):
        fg = (colour - (1.0 - a3) * checker_mid) / np.maximum(a3, floor_div)
    # Where the pixel is (near) clear the stored colour is meaningless. Lossy
    # WebP would bleed it back through the quantised alpha, so neutralise it.
    fg = np.where(a3 > 0.02, fg, checker_mid)
    fg = np.clip(fg, 0, 255)

    if vfade is not None:
        alpha = alpha * _vertical_ramp(alpha.shape[0], vfade)[:, None]

    out = np.concatenate([fg, alpha[..., None] * 255.0], axis=2).astype(np.uint8)
    img = Image.fromarray(out, "RGBA")
    if img.size != CANVAS:
        img = img.resize(CANVAS, Image.LANCZOS)
    return img


def _vertical_ramp(
    height: int, stops: tuple[float, float, float, float]
) -> np.ndarray:
    """0 -> 1 -> 1 -> 0 over four normalised y positions, smoothly."""
    y = np.arange(height, dtype=np.float32) / height
    a0, a1, b0, b1 = stops
    rise = np.clip((y - a0) / max(a1 - a0, 1e-6), 0, 1)
    fall = 1.0 - np.clip((y - b0) / max(b1 - b0, 1e-6), 0, 1)
    ramp = np.minimum(rise, fall)
    return ramp * ramp * (3 - 2 * ramp)  # smoothstep


def save_webp(img: Image.Image, path: str, quality: int) -> int:
    img.save(path, "WEBP", quality=quality, method=6, alpha_quality=100)
    return os.path.getsize(path)


def save_png(img: Image.Image, path: str) -> int:
    """Lossless RGBA. Used only where the alpha channel carries the artwork."""
    img.save(path, "PNG", optimize=True)
    return os.path.getsize(path)


def save_layer(img: Image.Image, directory: str, name: str, fmt: str) -> tuple[str, int]:
    """Writes `name` in `fmt` and returns (filename, bytes)."""
    filename = f"{name}.{fmt}"
    path = os.path.join(directory, filename)
    size = save_png(img, path) if fmt == "png" else save_webp(img, path, 92)
    return filename, size


def main() -> None:
    archive_originals()

    print("\n-- background layers --")
    total_before = total_after = 0
    base_src = source_png("backgrounds", "guardian_valley_base.png")
    base = Image.open(base_src).convert("RGB")
    if base.size != CANVAS:
        base = base.resize(CANVAS, Image.LANCZOS)
    before = os.path.getsize(base_src)
    after = save_webp(base, os.path.join(SRC_BG, "guardian_valley_base.webp"), 92)
    total_before += before
    total_after += after
    print(f"  guardian_valley_base       {before // 1024:>5} KB -> {after // 1024:>4} KB (opaque)")

    for name, raw_cfg in LAYERS.items():
        cfg = dict(raw_cfg)
        fmt = cfg.pop("fmt", "webp")
        src = source_png("backgrounds", name + ".png")
        print(f"  {name}")
        img = dematte(src, **cfg)
        alpha = np.asarray(img)[..., 3]
        clear = float((alpha < 8).mean()) * 100
        before = os.path.getsize(src)
        filename, after = save_layer(img, SRC_BG, name, fmt)
        total_before += before
        total_after += after
        print(
            f"    {before // 1024:>5} KB -> {after // 1024:>4} KB   "
            f"transparent area {clear:.1f}%   -> {filename}"
        )

    print("\n-- guardian emotions --")
    guardian_dir = os.path.join(ARCHIVE, "guardian")
    if not os.path.isdir(guardian_dir):
        guardian_dir = SRC_GUARDIAN
    for name in sorted(os.listdir(guardian_dir)):
        if not name.endswith(".png"):
            continue
        src = os.path.join(guardian_dir, name)
        img = Image.open(src).convert("RGBA")
        before = os.path.getsize(src)
        after = save_webp(img, os.path.join(SRC_GUARDIAN, name[:-4] + ".webp"), 94)
        total_before += before
        total_after += after
        print(f"  {name[:-4]:<24} {before // 1024:>5} KB -> {after // 1024:>4} KB")

    print(
        f"\ntotal {total_before // 1024} KB -> {total_after // 1024} KB "
        f"({100 - total_after * 100 // total_before}% smaller)"
    )


if __name__ == "__main__":
    main()
