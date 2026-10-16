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
icon=$(LC_ALL=C APP_NAME="$app_name" awk -F '\t' '
  BEGIN { app = ENVIRON["APP_NAME"] }
  $2 == app { print $1; matched = 1; exit }
  $2 == "" { fallback = $1; next }
  !prefix && substr($2, length($2)) == "*" && index(app, substr($2, 1, length($2) - 1)) == 1 {
    prefix = $1
  }
  END { if (!matched) print prefix ? prefix : fallback }
' "$(dirname "$0")/app_icons.tsv") || exit 1
sketchybar --set "$NAME" drawing=on label="$app_name" icon="$icon"
