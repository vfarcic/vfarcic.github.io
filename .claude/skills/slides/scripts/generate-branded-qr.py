#!/usr/bin/env python3
"""Create an SVG QR with high error correction and a small embedded SVG logo."""

import argparse
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("url")
    parser.add_argument("logo", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    encoded = subprocess.run(
        ["qrencode", "--type=SVG", "--level=H", "--margin=4", "--size=12", "--svg-path", "--output=-", args.url],
        check=True, capture_output=True, text=True,
    )
    namespace = "http://www.w3.org/2000/svg"
    ET.register_namespace("", namespace)
    qr = ET.fromstring(encoded.stdout)
    width, height = map(float, qr.attrib["viewBox"].split()[2:])
    # SVG geometry uses module units; qrencode's physical cm dimensions do not.
    qr.set("width", f"{width * 12:g}")
    qr.set("height", f"{height * 12:g}")
    ET.SubElement(qr, f"{{{namespace}}}title").text = f"QR code for {args.url}"
    plate = min(width, height) * 0.20
    ET.SubElement(qr, f"{{{namespace}}}rect", {
        "x": f"{(width - plate) / 2:g}", "y": f"{(height - plate) / 2:g}",
        "width": f"{plate:g}", "height": f"{plate:g}", "fill": "white",
    })
    logo = ET.parse(args.logo).getroot()
    size = min(width, height) * 0.16
    logo.set("x", f"{(width - size) / 2:g}")
    logo.set("y", f"{(height - size) / 2:g}")
    logo.set("width", f"{size:g}")
    logo.set("height", f"{size:g}")
    logo.set("shape-rendering", "geometricPrecision")
    qr.append(logo)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(qr).write(args.output, encoding="utf-8", xml_declaration=True)
    print(f"Created branded QR: {args.output}")


if __name__ == "__main__":
    main()
