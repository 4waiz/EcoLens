"""Regenerate ONLY the cloud plate, as a lossless PNG.

Why this exists as its own entry point: `prepare_art_assets.py` rewrites every
background and Guardian frame, which is more churn than is wanted when the only
plate that has changed is the clouds. This reuses that script's `dematte()` so
the de-matte algorithm still has exactly one implementation.

The clouds are the one plate whose picture lives in the ALPHA channel — pure
white drawn at partial opacity — so:

  * they are solved with `mode="white"`, which reconstructs `a` from
    `observed = a*255 + (1-a)*checker` and writes pure-white RGB. A plate that
    keeps the checker's grey in RGB paints a visible grid across the sky;
  * they are written as PNG, never WebP, because WebP's lossy alpha put blocking
    into the soft cloud edges.

Usage:  python tool/rebuild_cloud_plate.py
"""

from __future__ import annotations

import os
import sys

import numpy as np
from PIL import Image

from prepare_art_assets import CANVAS, LAYERS, dematte  # noqa: E402

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NAME = "guardian_valley_clouds"
MASTER = os.path.join(REPO, "art_source", "backgrounds", f"{NAME}.png")
OUT = os.path.join(REPO, "assets", "backgrounds", f"{NAME}.png")


def report(path: str, label: str) -> None:
    """Print the two numbers that decide whether this plate is usable."""
    rgba = np.asarray(Image.open(path).convert("RGBA"), dtype=np.uint8)
    rgb, alpha = rgba[..., :3], rgba[..., 3]
    visible = alpha > 16
    count = int(visible.sum())
    if count == 0:
        print(f"  {label}: nothing visible")
        return
    not_white = visible & (rgb.min(axis=2) < 245)
    print(
        f"  {label}: {rgba.shape[1]}x{rgba.shape[0]}, "
        f"{(alpha < 8).mean() * 100:.1f}% clear, "
        f"{not_white.sum() / count * 100:.1f}% of visible pixels not white"
    )


def main() -> int:
    if not os.path.exists(MASTER):
        print(f"master not found: {MASTER}", file=sys.stderr)
        return 1

    config = dict(LAYERS[NAME])
    config.pop("fmt", None)

    print("before:")
    if os.path.exists(OUT):
        report(OUT, "shipped")

    image = dematte(MASTER, **config)
    if image.size != CANVAS:
        image = image.resize(CANVAS, Image.LANCZOS)
    image.save(OUT, "PNG", optimize=True)

    print("after:")
    report(OUT, "shipped")
    print(f"  {os.path.getsize(OUT) // 1024} KB -> {os.path.relpath(OUT, REPO)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
