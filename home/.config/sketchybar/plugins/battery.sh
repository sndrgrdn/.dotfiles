#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
. "$CONFIG_DIR/colors.sh"
status=$(pmset -g batt) || exit 1
percentage=$(printf '%s\n' "$status" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
args=()
if [ -z "$percentage" ]; then
  args+=(--set "$NAME" drawing=off)
  for segment in 1 2 3 4 5; do
    args+=(--set "battery.$segment" drawing=off)
  done
  sketchybar "${args[@]}"
  exit 0
fi

color=$COLOR_FOREGROUND
if printf '%s\n' "$status" | grep -q 'AC Power'; then
  color=$COLOR_GREEN
elif [ "$percentage" -le 20 ]; then
  color=$COLOR_RED
fi

filled=$(( (percentage + 19) / 20 ))
for segment in 1 2 3 4 5; do
  segment_color=$COLOR_MUTED
  [ "$segment" -le "$filled" ] && segment_color="$color"
  args+=(--set "battery.$segment" drawing=on background.color="$segment_color")
done
args+=(--set "$NAME" drawing=on label="$percentage%" label.color=$COLOR_FOREGROUND)
sketchybar "${args[@]}"
