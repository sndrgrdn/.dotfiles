#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Home Assistant in Helium
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🏠
# @raycast.packageName App Launchers
# @raycast.description Opens Home Assistant in Helium app mode

/Applications/Helium.app/Contents/MacOS/Helium --app=http://homeassistant.local:8123/ >/dev/null 2>&1 &
