#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
workspaces=$(dinky list-workspaces --all \
  --format '%{workspace} %{workspace-is-focused} %{monitor-id}') || exit 1

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
    args+=(background.drawing=on icon.color=0xffcad3f5)
  else
    args+=(background.drawing=off icon.color=0xff8087a2)
  fi
done <<<"$workspaces"

[ "${#args[@]}" -gt 0 ] && sketchybar "${args[@]}"
