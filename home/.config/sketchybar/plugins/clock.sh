#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
sketchybar --set "$NAME" label="$(date '+%H:%M')"
