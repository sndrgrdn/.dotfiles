#!/usr/bin/env ruby

require "json"
require_relative "sketchybar"

def session_unlocked?
  registry = SketchyBar.capture("/usr/sbin/ioreg", "-a", "-n", "Root", "-d1")
  return false unless registry

  json = SketchyBar.capture(
    "/usr/bin/plutil", "-extract", "IOConsoleUsers", "json", "-o", "-", "-",
    stdin_data: registry
  )
  return false unless json

  sessions = JSON.parse(json)

  sessions.any? do |session|
    session["kCGSSessionUserIDKey"] == Process.uid &&
      session["kCGSSessionOnConsoleKey"] &&
      session["kCGSessionLoginDoneKey"] &&
      !session["CGSSessionScreenIsLocked"]
  end
end

exit 0 unless session_unlocked?
if ENV["SENDER"] == "screen_unlocked"
  sleep 10
  exit 0 unless session_unlocked?
end

weather = SketchyBar.capture(
  "/usr/bin/shortcuts", "run", "Current Weather", "--output-type", "public.plain-text",
  timeout: 30
)
match = weather&.tr("−", "-")&.match(/\A\s*([+-]?\d+(?:[.,]\d+)?)\s*°\s*C\s+and\s+([^\r\n\t]+)\s*\z/)

if match && !match[2].strip.empty?
  condition = match[2].strip.downcase
  icons = {
    /thunder|lightning/ => "cloud.bolt.rain",
    /sleet|freez|hail|ice/ => "cloud.sleet",
    /snow|blizzard|flurr/ => "cloud.snow",
    /rain|drizzle|shower/ => "cloud.rain",
    /fog|mist|haze/ => "cloud.fog",
    /partly/ => "cloud.sun",
    /cloud|overcast/ => "cloud",
    /clear|sunny/ => "sun.max"
  }
  icon = icons.find { |pattern, _| pattern.match?(condition) }&.last || "cloud"
  label = "#{match[1]}°C"
  color = "0xffa5adcb"
else
  icon = "cloud"
  label = "--°C"
  color = "0xff8087a2"
end

properties = {
  "icon.background.image" => "#{ENV.fetch("CONFIG_DIR")}/icons/#{icon}.png",
  label:,
  "label.color" => color
}
SketchyBar.update(ENV.fetch("NAME") => properties)
