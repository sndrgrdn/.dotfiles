#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
. "$CONFIG_DIR/colors.sh"

workspaces=$(dinky list-workspaces --all \
  --format '%{workspace} %{workspace-is-focused} %{monitor-id} %{workspace-layout}') || exit 1
empty_workspaces=$(dinky list-workspaces --all --empty) || exit 1
empty_workspaces=" ${empty_workspaces//$'\n'/ } "
empty_color=$(printf '0x%08x' $(((COLOR_FOREGROUND & 0xffffff) | 0x80000000)))

args=()
while read -r workspace focused monitor layout; do
  [ -n "$workspace" ] || continue
  selected="$focused"
  if [ "$SENDER" = dinky_workspace_changing ] && [ "$monitor" = "$DINKY_DISPLAY" ]; then
    selected=false
    [ "$workspace" = "$DINKY_WORKSPACE" ] && selected=true
  fi
  args+=(--set "workspace.$workspace" display="$monitor")
  if [ "$selected" = true ]; then
    case "$layout" in
      scrolling) glyph=󰝥 ;;
      *) glyph=󱓻 ;;
    esac
    args+=(icon="$glyph" icon.color=$COLOR_FOREGROUND)
  else
    color=$COLOR_FOREGROUND
    [[ "$empty_workspaces" = *" $workspace "* ]] && color=$empty_color
    args+=(icon="$workspace" icon.color=$color)
  fi
done <<<"$workspaces"

[ "${#args[@]}" -gt 0 ] && sketchybar "${args[@]}"
