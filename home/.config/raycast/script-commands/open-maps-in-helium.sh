#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Maps in Helium
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗺️
# @raycast.packageName App Launchers
# @raycast.description Opens Google Maps in Helium app mode

/Applications/Helium.app/Contents/MacOS/Helium --app=https://maps.google.com >/dev/null 2>&1 &
