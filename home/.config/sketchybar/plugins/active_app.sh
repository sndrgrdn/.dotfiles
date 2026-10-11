#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
windows=$(dinky list-windows --workspace focused --format '%{window-id}') || exit 1
if [ -z "$windows" ]; then
  sketchybar --set "$NAME" drawing=off label= icon=
  exit 0
fi

if [ "$SENDER" = front_app_switched ]; then
  app_name="$INFO"
else
  app_name=$(/usr/bin/osascript -l JavaScript -e \
    'ObjC.import("AppKit"); $.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName.js') || exit 1
fi

[ -n "$app_name" ] || exit 1
icon=$(python3 "$(dirname "$0")/app_icon.py" "$app_name") || exit 1
sketchybar --set "$NAME" drawing=on label="$app_name" icon="$icon"
