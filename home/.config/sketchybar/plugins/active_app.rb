#!/usr/bin/env ruby

require "json"
require_relative "sketchybar"

def app_icon(app_name)
  font = File.binread(File.expand_path("~/Library/Fonts/sketchybar-app-font.ttf"))
  tables = font.unpack1("n", offset: 4).times.to_h do |index|
    tag, _, offset, = font.unpack("a4N3", offset: 12 + (index * 16))
    [tag, offset]
  end

  meta_offset = tables.fetch("meta")
  record_count = font.unpack1("N", offset: meta_offset + 12)
  record = record_count.times.lazy.map do |index|
    font.unpack("a4N2", offset: meta_offset + 16 + (index * 12))
  end.find { |tag, _, _| tag == "APPM" }

  _, offset, length = record
  mapping = JSON.parse(font.byteslice(meta_offset + offset, length))

  icons = mapping.fetch("icons")
  entry = icons.find { |_, _, names| Array(names).include?(app_name) }
  entry ||= icons.find do |_, _, names|
    Array(names).any? { |name| name.end_with?("*") && app_name.start_with?(name.delete_suffix("*")) }
  end
  entry ||= icons.find { |ligature, _, _| ligature == ":default:" }

  entry.fetch(1).chr(Encoding::UTF_8)
end

windows = SketchyBar.capture("dinky", "list-windows", "--workspace", "focused", "--format", "%{window-id}")
exit 1 unless windows

if windows.strip.empty?
  SketchyBar.update(ENV.fetch("NAME") => { drawing: "off", label: "", icon: "" })
  exit 0
end

app_name = if ENV["SENDER"] == "front_app_switched"
             ENV.fetch("INFO")
           else
             SketchyBar.capture(
               "/usr/bin/osascript", "-l", "JavaScript", "-e",
               'ObjC.import("AppKit"); $.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName.js'
             )
           end
exit 1 unless app_name

app_name = app_name.rstrip
icon = app_icon(app_name)
SketchyBar.update(ENV.fetch("NAME") => { drawing: "on", label: app_name, icon: icon })
