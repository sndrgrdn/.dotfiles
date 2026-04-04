# Dotfiles

Personal macOS dotfiles managed from `~/.dotfiles` with GNU Stow and Homebrew.

## Layout

```text
~/.dotfiles/
├── dot
├── Brewfile
├── home/
├── PLAN.md
└── README.md
```

## Commands

- `dot init`: install core dependencies, apply the Brewfile, set Fish as the default shell, and stow configs
- `dot stow`: apply managed files from `home/`
- `dot stow --dry-run`: preview the stow operation
- `dot doctor`: verify repo structure, Brewfile compliance, and managed symlink state
- `dot update`: pull repo changes, update Homebrew packages, re-run the Brewfile, and re-stow
- `dot link`: create `~/.local/bin/dot`
- `dot unlink`: remove `~/.local/bin/dot`

## Managed In V1

- Fish config under `home/.config/fish/`
- Git config under `home/.config/git/`
- Ghostty config under `home/.config/ghostty/config`
- Starship config under `home/.config/starship.toml`

Excluded from the first pass:

- `fish_variables`
- zsh files
- identity automation
- AI helper commands in the CLI

## Notes

- The canonical package manifest is `~/.dotfiles/Brewfile`
- The repo is the source of truth; `dot` applies it to your home directory
- The first migration backs up old live files to `~/.dotfiles-backups/<timestamp>/`
