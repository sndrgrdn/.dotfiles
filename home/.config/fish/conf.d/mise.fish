# Mise (shims activation: shims dir moved to front of PATH so mise tools
# beat /usr/bin system binaries like ruby; brew-first ordering untouched)
~/.local/bin/mise activate fish --shims | source
