#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open YouTube in Helium
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📺
# @raycast.packageName App Launchers
# @raycast.description Opens YouTube in Helium app mode

/Applications/Helium.app/Contents/MacOS/Helium --app=https://youtube.com >/dev/null 2>&1 &
