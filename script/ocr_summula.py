#!/usr/bin/env python3

from __future__ import annotations

import os
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image, ImageFilter, ImageOps
from rapidocr_onnxruntime import RapidOCR

OCR_ENGINE = RapidOCR()


def load_image(source_path: Path) -> Image.Image:
    image = Image.open(source_path)
    image = ImageOps.exif_transpose(image).convert("RGB")

    if image.width < 1800:
        scale = 1800 / max(image.width, 1)
        new_size = (int(image.width * scale), int(image.height * scale))
        image = image.resize(new_size)

    return image


def preprocess_region(image: Image.Image) -> Path:
    image = ImageOps.grayscale(image)
    image = ImageOps.autocontrast(image)
    image = image.filter(ImageFilter.SHARPEN)

    handle = tempfile.NamedTemporaryFile(suffix=".png", delete=False)
    handle.close()
    image.save(handle.name)
    return Path(handle.name)


def convert_pdf_first_page(source_path: Path) -> Path:
    handle = tempfile.NamedTemporaryFile(suffix=".png", delete=False)
    handle.close()
    prefix = Path(handle.name).with_suffix("")
    subprocess.run(
        ["pdftoppm", "-f", "1", "-singlefile", "-png", str(source_path), str(prefix)],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return Path(f"{prefix}.png")


def grouped_text(items) -> str:
    rows = []
    for box, text, score in items:
        xs = [point[0] for point in box]
        ys = [point[1] for point in box]
        center_x = sum(xs) / len(xs)
        center_y = sum(ys) / len(ys)
        height = max(ys) - min(ys)
        rows.append((center_y, center_x, height, text))

    rows.sort(key=lambda row: (row[0], row[1]))

    lines = []
    current = []
    current_y = None
    current_height = None

    for center_y, center_x, height, text in rows:
        threshold = max(14, (current_height or height or 18) * 0.55)
        if current and current_y is not None and center_y - current_y > threshold:
            lines.append(" ".join(part for _, part in sorted(current, key=lambda row: row[0])).strip())
            current = []
        current.append((center_x, text))
        current_y = center_y
        current_height = height if current_height is None else max(current_height, height)

    if current:
        lines.append(" ".join(part for _, part in sorted(current, key=lambda row: row[0])).strip())

    return "\n".join(line for line in lines if line)


def ocr_region(image: Image.Image, box: tuple[int, int, int, int]) -> str:
    region = image.crop(box)
    prepared = preprocess_region(region)

    try:
        result, _ = OCR_ENGINE(str(prepared))
        if not result:
            return ""
        return grouped_text(result)
    finally:
        try:
            os.unlink(prepared)
        except OSError:
            pass


def crop_boxes(image: Image.Image) -> dict[str, tuple[int, int, int, int]]:
    width, height = image.size
    left = int(width * 0.03)
    right = int(width * 0.97)
    top = 0
    header_bottom = int(height * 0.43)
    team_a_top = int(height * 0.31)
    team_a_bottom = int(height * 0.70)
    team_b_top = int(height * 0.58)
    team_b_bottom = int(height * 0.98)

    return {
        "HEADER": (left, top, right, header_bottom),
        "TEAM_A": (left, team_a_top, right, team_a_bottom),
        "TEAM_B": (left, team_b_top, right, team_b_bottom),
    }


def ocr(source_path: Path) -> str:
    temp_source = None
    if source_path.suffix.lower() == ".pdf":
        temp_source = convert_pdf_first_page(source_path)
    else:
        temp_source = source_path

    try:
        base_image = load_image(temp_source)
        sections = []
        for label, box in crop_boxes(base_image).items():
            text = ocr_region(base_image, box)
            if text.strip():
                sections.append(f"[[{label}]]")
                sections.append(text)

        if sections:
            return "\n".join(sections)

        fallback_path = preprocess_region(base_image)
        try:
            result, _ = OCR_ENGINE(str(fallback_path))
            if not result:
                return ""
            return grouped_text(result)
        finally:
            try:
                os.unlink(fallback_path)
            except OSError:
                pass
    finally:
        if source_path.suffix.lower() == ".pdf":
            try:
                os.unlink(temp_source)
            except OSError:
                pass


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: ocr_summula.py <path>", file=sys.stderr)
        return 2

    source_path = Path(sys.argv[1])
    if not source_path.exists():
        print("input file not found", file=sys.stderr)
        return 2

    try:
        print(ocr(source_path))
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
