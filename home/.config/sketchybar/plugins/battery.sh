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

color=0xffcad3f5
if printf '%s\n' "$status" | grep -q 'AC Power'; then
  color=0xffa6da95
elif [ "$percentage" -le 20 ]; then
  color=0xffed8796
fi

filled=$(( (percentage + 19) / 20 ))
for segment in 1 2 3 4 5; do
  segment_color=0xff363a4f
  [ "$segment" -le "$filled" ] && segment_color="$color"
  args+=(--set "battery.$segment" drawing=on background.color="$segment_color")
done
args+=(--set "$NAME" drawing=on label="$percentage%" label.color=0xffa5adcb)
sketchybar "${args[@]}"
