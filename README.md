# Dotfiles

`sndrgrdn` macOS dev env. GNU Stow + Homebrew.

## Quick Start

```bash
git clone https://github.com/sndrgrdn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./dot init
```

## Structure

```
.dotfiles/
├── dot                 # CLI: init/update/doctor/stow/package
├── Brewfile            # Homebrew manifest
└── home/.config/       # Stowed to ~/.config/
    ├── fish/           # Shell
    ├── git/            # Git config + ignore
    ├── mise/           # Runtime versions
    ├── ghostty/        # Terminal
    └── starship.toml   # Prompt
```

## Commands

```bash
dot init              # First-time setup
dot update            # Pull, upgrade, restow
dot doctor            # Health check
dot stow              # Apply dotfiles
dot stow --dry-run    # Preview changes
dot package add X     # Add package
dot edit              # Open in $EDITOR
```

## Managed

| Tool | Config | Notes |
|------|--------|-------|
| Fish | `fish/config.fish` | No greeting |
| Git | `git/config` | Delta, zdiff3, rebase |
| Mise | `mise/config.toml` | Ruby, Node LTS, bun |
| Ghostty | `ghostty/config` | JetBrains Mono, Catppuccin Macchiato |
| Starship | `starship.toml` | Minimal |

## Conventions

- **Stow:** `home/` mirrors `~`
- **Brewfile:** Formulas → casks, alphabetized
- **Theme:** Catppuccin Macchiato
- **Safety:** `trash` not `rm -rf`

## Customize

```bash
# Add package
dot package add ripgrep
dot package add cursor cask

# Edit configs in home/, then:
dot stow && dot doctor
```

## Notes

- Repo is source of truth
- `fish_variables` gitignored
- Backups to `~/.dotfiles-backups/<timestamp>/`
