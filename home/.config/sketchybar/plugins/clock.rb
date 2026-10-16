#!/usr/bin/env ruby

require_relative "sketchybar"

SketchyBar.update(ENV.fetch("NAME") => { label: Time.now.strftime("%H:%M") })
