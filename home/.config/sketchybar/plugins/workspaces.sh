#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
. "$CONFIG_DIR/colors.sh"
case "$SENDER" in
  mouse.entered)
    sketchybar --set "$NAME" icon.background.drawing=on
    exit $?
    ;;
  mouse.exited)
    sketchybar --set "$NAME" icon.background.drawing=off
    exit $?
    ;;
esac
[ "$NAME" = workspace_observer ] || exit 0

workspaces=$(dinky list-workspaces --all \
  --format '%{workspace} %{workspace-is-focused} %{monitor-id}') || exit 1
empty_workspaces=$(dinky list-workspaces --all --empty) || exit 1
empty_workspaces=" ${empty_workspaces//$'\n'/ } "

args=()
while read -r workspace focused monitor; do
  [ -n "$workspace" ] || continue
  selected="$focused"
  if [ "$SENDER" = dinky_workspace_changing ] && [ "$monitor" = "$DINKY_DISPLAY" ]; then
    selected=false
    [ "$workspace" = "$DINKY_WORKSPACE" ] && selected=true
  fi
  args+=(--set "workspace.$workspace" display="$monitor")
  if [ "$selected" = true ]; then
    args+=(background.drawing=on icon.color=$COLOR_BRIGHT_FOREGROUND)
  elif [[ "$empty_workspaces" = *" $workspace "* ]]; then
    args+=(background.drawing=off icon.color=$COLOR_MUTED)
  else
    args+=(background.drawing=off icon.color=$COLOR_FOREGROUND)
  fi
done <<<"$workspaces"

[ "${#args[@]}" -gt 0 ] && sketchybar "${args[@]}"
