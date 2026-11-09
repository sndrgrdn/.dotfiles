#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
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

color=0xffa9b1d6
if printf '%s\n' "$status" | grep -q 'AC Power'; then
  color=0xff9ece6a
elif [ "$percentage" -le 20 ]; then
  color=0xfff7768e
fi

filled=$(( (percentage + 19) / 20 ))
for segment in 1 2 3 4 5; do
  segment_color=0xff414868
  [ "$segment" -le "$filled" ] && segment_color="$color"
  args+=(--set "battery.$segment" drawing=on background.color="$segment_color")
done
args+=(--set "$NAME" drawing=on label="$percentage%" label.color=0xffa9b1d6)
sketchybar "${args[@]}"
