#!/bin/bash

set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"
font="$HOME/Library/Fonts/sketchybar-app-font.ttf"

read_uint() {
  local bytes=() value=0 byte
  read -r -a bytes <<<"$(od -An -tu1 -j "$1" -N "$2" "$font")"
  for byte in "${bytes[@]}"; do
    value=$((value * 256 + byte))
  done
  printf '%d\n' "$value"
}

read_tag() {
  dd if="$font" bs=1 skip="$1" count=4 2>/dev/null
}

table_count=$(read_uint 4 2)
for ((index = 0; index < table_count; index++)); do
  offset=$((12 + index * 16))
  if [ "$(read_tag "$offset")" = meta ]; then
    meta_offset=$(read_uint "$((offset + 8))" 4)
    break
  fi
done

record_count=$(read_uint "$((meta_offset + 12))" 4)
for ((index = 0; index < record_count; index++)); do
  offset=$((meta_offset + 16 + index * 12))
  if [ "$(read_tag "$offset")" = APPM ]; then
    data_offset=$(read_uint "$((offset + 4))" 4)
    data_length=$(read_uint "$((offset + 8))" 4)
    break
  fi
done

mapping=$(dd if="$font" bs=1 skip="$((meta_offset + data_offset))" count="$data_length" 2>/dev/null |
  jq -r '.icons[] | ([.[1]] | implode) as $icon |
    ((select(.[0] == ":default:") | [$icon, ""]), (.[2][]? | [$icon, .])) | join("\t") | rtrimstr("\t")')
printf '%s\n' "$mapping" >"$(dirname "$0")/app_icons.tsv"
