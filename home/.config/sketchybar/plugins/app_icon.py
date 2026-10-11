import json
from pathlib import Path
import struct
import sys


def load_icons(font_path):
    data = font_path.read_bytes()
    tables = {}
    for index in range(struct.unpack_from(">H", data, 4)[0]):
        tag, checksum, offset, length = struct.unpack_from(">4sIII", data, 12 + index * 16)
        tables[tag] = offset

    meta_offset = tables[b"meta"]
    for index in range(struct.unpack_from(">I", data, meta_offset + 12)[0]):
        tag, offset, length = struct.unpack_from(">4sII", data, meta_offset + 16 + index * 12)
        if tag == b"APPM":
            mapping = json.loads(data[meta_offset + offset:meta_offset + offset + length])
            if mapping["version"] != 1:
                raise ValueError("Unsupported app-icon mapping schema")
            return mapping["icons"]
    raise ValueError("App-icon mapping is missing from the font")


def icon_for_app(icons, app_name):
    for ligature, codepoint, app_names in icons:
        if app_name in (app_names or []):
            return chr(codepoint)
    for ligature, codepoint, app_names in icons:
        for name in app_names or []:
            if name.endswith("*") and app_name.startswith(name[:-1]):
                return chr(codepoint)
    return next(chr(codepoint) for ligature, codepoint, app_names in icons if ligature == ":default:")


if __name__ == "__main__":
    icons = load_icons(Path.home() / "Library/Fonts/sketchybar-app-font.ttf")
    print(icon_for_app(icons, sys.argv[1]))
