#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Gmail in Helium
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ✉️
# @raycast.packageName App Launchers
# @raycast.description Opens Gmail in Helium app mode

/Applications/Helium.app/Contents/MacOS/Helium --app=https://mail.google.com >/dev/null 2>&1 &
