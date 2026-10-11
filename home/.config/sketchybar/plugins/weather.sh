#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
weather=$(python3 - <<'PY'
import re
import subprocess
import sys

try:
    result = subprocess.run(
        ["/usr/bin/shortcuts", "run", "Current Weather", "--output-type", "public.plain-text"],
        capture_output=True, text=True, check=True, timeout=30,
    )
except (OSError, subprocess.SubprocessError):
    sys.exit(1)

match = re.fullmatch(
    r"\s*([+-]?\d+(?:[.,]\d+)?)\s*°\s*C\s+and\s+([^\r\n\t]+)\s*",
    result.stdout.replace("−", "-"),
)
if match is None or not match[2].strip():
    sys.exit(1)
print(f"{match[1]}\t{match[2].strip().casefold()}")
PY
) || {
  sketchybar --set "$NAME" icon.background.image="$CONFIG_DIR/icons/cloud.png" label="--°C" label.color=0xff8087a2
  exit 0
}

IFS=$'\t' read -r temperature condition <<<"$weather"
case "$condition" in
  *thunder*|*lightning*) icon=cloud.bolt.rain ;;
  *sleet*|*freez*|*hail*|*ice*) icon=cloud.sleet ;;
  *snow*|*blizzard*|*flurr*) icon=cloud.snow ;;
  *rain*|*drizzle*|*shower*) icon=cloud.rain ;;
  *fog*|*mist*|*haze*) icon=cloud.fog ;;
  *partly*) icon=cloud.sun ;;
  *cloud*|*overcast*) icon=cloud ;;
  *clear*|*sunny*) icon=sun.max ;;
  *) icon=cloud ;;
esac

sketchybar --set "$NAME" icon.background.image="$CONFIG_DIR/icons/$icon.png" label="${temperature}°C" label.color=0xffa5adcb
