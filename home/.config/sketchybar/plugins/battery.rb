#!/usr/bin/env ruby

require_relative "sketchybar"

status = SketchyBar.capture("/usr/bin/pmset", "-g", "batt")
exit 1 unless status

name = ENV.fetch("NAME")
match = status.match(/(\d+)%/)

unless match
  items = [name, *(1..5).map { |segment| "battery.#{segment}" }]
  SketchyBar.update(items.to_h { |item| [item, { drawing: "off" }] })
  exit 0
end

percentage = match[1].to_i
color = if status.include?("AC Power")
          "0xffa6da95"
        elsif percentage <= 20
          "0xffed8796"
        else
          "0xffcad3f5"
        end

filled = (percentage + 19) / 20
updates = (1..5).to_h do |segment|
  ["battery.#{segment}", { drawing: "on", "background.color" => segment <= filled ? color : "0xff363a4f" }]
end
updates[name] = { drawing: "on", label: "#{percentage}%", "label.color" => "0xffa5adcb" }
SketchyBar.update(updates)
