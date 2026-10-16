#!/usr/bin/env ruby

require_relative "sketchybar"

workspaces = SketchyBar.capture(
  "dinky", "list-workspaces", "--all",
  "--format", "%{workspace} %{workspace-is-focused} %{monitor-id}"
)
exit 1 unless workspaces

updates = workspaces.lines.filter_map do |line|
  workspace, focused, monitor = line.split
  next unless workspace

  selected = focused == "true"
  if ENV["SENDER"] == "dinky_workspace_changing" && monitor == ENV["DINKY_DISPLAY"]
    selected = workspace == ENV["DINKY_WORKSPACE"]
  end

  ["workspace.#{workspace}", {
    display: monitor,
    "background.drawing" => selected ? "on" : "off",
    "icon.color" => selected ? "0xffcad3f5" : "0xff8087a2"
  }]
end.to_h

SketchyBar.update(updates)
