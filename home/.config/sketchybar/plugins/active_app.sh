#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
if ! app_name=$(dinky list-windows --focused --workspace focused --format '%{app-name}' 2>/dev/null); then
  sketchybar --set "$NAME" drawing=off label= icon=
  exit 0
fi

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
