# Dotfiles

Personal macOS development environment managed with GNU Stow + Homebrew.

## Quick Start

```bash
# Clone and setup
git clone https://github.com/username/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dot init
```

After installation, the `dot` command is available globally for ongoing management.

## Structure

```
.dotfiles/
├── dot                 # CLI: init/update/doctor/stow/package
├── Brewfile            # Homebrew bundle manifest
├── home/.config/       # Stowed to ~/.config/
│   ├── fish/           # Shell configuration
│   ├── git/            # Git config + global ignore
│   ├── mise/           # Runtime version manager
│   ├── gh/             # GitHub CLI config
│   ├── ghostty/        # Terminal emulator
│   ├── opencode/       # AI agent config
│   └── starship.toml   # Shell prompt
└── README.md
```

## Commands

### Setup & Maintenance

```bash
dot init              # First-time setup (brew, stow, shell)
dot update            # Pull repo, upgrade packages, restow
dot doctor            # Health check (symlinks, packages, tools)
```

### Package Management

```bash
dot package add <name>        # Add to Brewfile and install
dot package remove <name>     # Remove from Brewfile
dot package list              # List all packages
dot package cleanup           # Clean Homebrew cache
```

### Utilities

```bash
dot stow              # Apply managed dotfiles to ~/
dot stow --dry-run    # Preview changes without applying
dot edit              # Open repo in $EDITOR
dot gen-ssh-key       # Generate ed25519 key by email domain
```

## What's Managed

| Component | Location | Notes |
|-----------|----------|-------|
| Fish shell | `home/.config/fish/` | Minimal config, no greeting |
| Git | `home/.config/git/` | Delta pager, zdiff3 merge, rebase on pull |
| Mise | `home/.config/mise/` | Ruby, Node LTS, bun |
| Ghostty | `home/.config/ghostty/` | JetBrains Mono, Catppuccin Macchiato |
| Starship | `home/.config/starship.toml` | Minimal prompt |

## Conventions

- **Stow layout:** `home/` mirrors `~`, stow creates symlinks
- **Brewfile:** Formulas first, then casks, alphabetized
- **Theme:** Catppuccin Macchiato across tools

## Customization

### Add a Package

```bash
dot package add ripgrep
dot package add cursor cask
```

### Modify Configurations

1. Edit files in `home/` (not `~/`)
2. Run `dot stow` to apply
3. Run `dot doctor` to verify

## Troubleshooting

**Command not found: `dot`**
```bash
export PATH="$HOME/.dotfiles:$PATH"
# Or run: ./dot link
```

**Broken symlinks:**
```bash
dot doctor
dot stow
```

**Package installation failures:**
```bash
dot check-packages
```

## Notes

- The repo is the source of truth; `dot` applies it to your home directory
- `fish_variables` is gitignored (auto-generated)
- First migration backs up old live files to `~/.dotfiles-backups/<timestamp>/`
- Backups created automatically when stowing would overwrite existing files
