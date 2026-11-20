#!/bin/bash

export COLOR_BACKGROUND=0xff1a1b26
export COLOR_FOREGROUND=0xffa9b1d6
export COLOR_DARK_FOREGROUND=0xff565f89
export COLOR_BRIGHT_FOREGROUND=0xffc0caf5
export COLOR_SELECTION=0xff292e42
export COLOR_ACCENT=0xff7aa2f7
export COLOR_MUTED=0xff414868
export COLOR_GREEN=0xff9ece6a
export COLOR_RED=0xfff7768e

THEME_COLORS="$HOME/Library/Application Support/Theme Switcher/current/sketchybar.sh"
[ -f "$THEME_COLORS" ] && . "$THEME_COLORS"
