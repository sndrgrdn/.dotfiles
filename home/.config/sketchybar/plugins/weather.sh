#!/bin/bash

set -o pipefail
export PATH="/opt/homebrew/bin:$PATH"

session_unlocked() {
  /usr/sbin/ioreg -a -n Root -d1 |
    /usr/bin/plutil -extract IOConsoleUsers json -o - - |
    jq -e --argjson uid "$UID" 'any(.[];
      .kCGSSessionUserIDKey == $uid and
      .kCGSSessionOnConsoleKey and
      .kCGSessionLoginDoneKey and
      (.CGSSessionScreenIsLocked | not)
    )' >/dev/null
}

session_unlocked || exit 0
if [ "$SENDER" = screen_unlocked ]; then
  sleep 10
  session_unlocked || exit 0
fi

icon=cloud
label='--°C'
color=0xff8087a2
pattern='^[[:space:]]*([+-]?[0-9]+([.,][0-9]+)?)[[:space:]]*°[[:space:]]*C[[:space:]]+and[[:space:]]+([^[:cntrl:]]+)[[:space:]]*$'
shopt -s nocasematch
if weather=$(timeout 30 /usr/bin/shortcuts run "Current Weather" --output-type public.plain-text) &&
  [[ ${weather//−/-} =~ $pattern ]] && [[ ${BASH_REMATCH[3]} = *[![:space:]]* ]]; then
  label="${BASH_REMATCH[1]}°C"
  condition=${BASH_REMATCH[3]}
  case "$condition" in
    *thunder*|*lightning*) icon=cloud.bolt.rain ;;
    *sleet*|*freez*|*hail*|*ice*) icon=cloud.sleet ;;
    *snow*|*blizzard*|*flurr*) icon=cloud.snow ;;
    *rain*|*drizzle*|*shower*) icon=cloud.rain ;;
    *fog*|*mist*|*haze*) icon=cloud.fog ;;
    *partly*) icon=cloud.sun ;;
    *cloud*|*overcast*) icon=cloud ;;
    *clear*|*sunny*) icon=sun.max ;;
  esac
  color=0xffa5adcb
fi

sketchybar --set "$NAME" icon.background.image="$CONFIG_DIR/icons/$icon.png" label="$label" label.color="$color"
