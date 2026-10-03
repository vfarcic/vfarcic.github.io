#!/usr/bin/env python3
"""Perspective-composite an authentic screenshot into a photographed monitor."""

import argparse
import json
import math
from pathlib import Path
import subprocess
import tempfile


def run(*arguments):
    return subprocess.run(["magick", *map(str, arguments)], check=True, capture_output=True, text=True).stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("photo", type=Path)
    parser.add_argument("screenshot", type=Path)
    parser.add_argument("corners", type=Path, help="JSON with top-left, top-right, bottom-right, bottom-left screen coordinates.")
    parser.add_argument("output", type=Path)
    parser.add_argument("--occlusion", type=Path, help="Optional foreground polygon to preserve in front of the screen.")
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Choose a new versioned output path; existing images are preserved.")
    corners = json.loads(args.corners.read_text())
    if len(corners) != 4 or any(len(point) != 2 for point in corners):
        parser.error("Provide four [x, y] screen corners in clockwise order, starting at top-left.")
    width, height = map(int, run("identify", "-format", "%w %h", args.photo).split())
    if any(not (0 <= x < width and 0 <= y < height) for x, y in corners):
        parser.error("Screen corners must be inside the photograph.")
    tl, tr, br, bl = corners
    panel_width = round((math.dist(tl, tr) + math.dist(bl, br)) / 2)
    panel_height = round((math.dist(tl, bl) + math.dist(tr, br)) / 2)
    if min(panel_width, panel_height) < 2:
        parser.error("The screen must have positive width and height.")
    source = [(0, 0), (panel_width - 1, 0), (panel_width - 1, panel_height - 1), (0, panel_height - 1)]
    mapping = " ".join(f"{sx},{sy} {dx},{dy}" for (sx, sy), (dx, dy) in zip(source, corners))
    occlusion = json.loads(args.occlusion.read_text()) if args.occlusion else None
    if occlusion and (len(occlusion) < 3 or any(len(point) != 2 for point in occlusion)):
        parser.error("The foreground mask must be a polygon of at least three [x, y] points.")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=args.output.parent) as temporary:
        panel = Path(temporary) / "panel.png"
        warped = Path(temporary) / "warped.png"
        # Preserve the screenshot's aspect ratio, letterboxing within the screen if needed.
        run(args.screenshot, "-filter", "Lanczos", "-resize", f"{panel_width}x{panel_height}",
            "-background", "#101815", "-gravity", "center", "-extent", f"{panel_width}x{panel_height}", panel)
        run(panel, "+repage", "-alpha", "set", "-virtual-pixel", "transparent",
            "-define", f"distort:viewport={width}x{height}+0+0", "-distort", "Perspective", mapping, warped)
        composited = Path(temporary) / "composited.png"
        run(args.photo, warped, "-compose", "Over", "-composite", composited)
        if occlusion:
            mask = Path(temporary) / "mask.png"
            foreground = Path(temporary) / "foreground.png"
            polygon = "polygon " + " ".join(f"{x},{y}" for x, y in occlusion)
            run("-size", f"{width}x{height}", "xc:black", "-fill", "white", "-stroke", "none", "-draw", polygon, mask)
            run(args.photo, mask, "-alpha", "off", "-compose", "CopyOpacity", "-composite", foreground)
            run(composited, foreground, "-compose", "Over", "-composite", "-depth", "8", args.output)
        else:
            run(composited, "-depth", "8", args.output)
    provenance = {
        "photo": str(args.photo), "screenshot": str(args.screenshot),
        "screen_corners": corners, "screenshot_preserves_aspect_ratio": True,
        "foreground_occlusion": occlusion,
    }
    Path(f"{args.output}.composition.json").write_text(json.dumps(provenance, indent=2) + "\n")
    print(f"Composited real interface into {args.output}")


if __name__ == "__main__":
    main()
