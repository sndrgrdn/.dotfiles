#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open X in Helium
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 𝕏
# @raycast.packageName App Launchers
# @raycast.description Opens X in Helium app mode

/Applications/Helium.app/Contents/MacOS/Helium --app=https://x.com >/dev/null 2>&1 &
