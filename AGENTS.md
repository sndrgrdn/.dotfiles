# DOTFILES

macOS dev env via GNU Stow + Homebrew. Fish + Git + Mise + Ghostty.

## STRUCTURE

```
.dotfiles/
├── dot                 # CLI: init/update/doctor/stow/package (850 lines bash)
├── Brewfile            # Homebrew bundle manifest
├── home/.config/       # Stowed to ~/.config/
│   ├── fish/           # Shell config
│   ├── git/            # Git config + global ignore
│   ├── mise/           # Runtime version manager
│   ├── gh/             # GitHub CLI config
│   ├── ghostty/        # Terminal emulator
│   ├── opencode/       # AI agent config
│   └── starship.toml   # Shell prompt
└── README.md
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add package | `dot package add <name>` or edit `Brewfile` |
| Shell config | `home/.config/fish/config.fish` |
| Git alias | `home/.config/git/config` [alias] section |
| Git ignore patterns | `home/.config/git/gitignore_global` |
| Runtime versions | `home/.config/mise/config.toml` [tools] |
| Terminal theme | `home/.config/ghostty/config` |

## CONVENTIONS

- Stow layout: `home/` mirrors `~`, stow creates symlinks
- Fish: minimal config, no greeting
- Git: delta pager, zdiff3 merge, rebase on pull
- Brewfile: formulas first, then casks, alphabetized
- Mise: latest Ruby/Node, bun for package management
- Theme: Catppuccin Macchiato across tools

## ANTI-PATTERNS

- Edit `~/.config/*` directly (changes lost on restow)
- Modify `fish_variables` (gitignored for a reason)
- `rm -rf` user data (use `trash` instead)
- Skip `dot doctor` after changes

## COMMANDS

```bash
dot init              # First-time setup (brew, stow, shell)
dot stow              # Apply managed dotfiles to ~/
dot stow --dry-run    # Preview changes without applying
dot doctor            # Health check (symlinks, packages, tools)
dot update            # Pull repo, upgrade packages, restow
dot package add X     # Add to Brewfile and install
dot package remove X  # Remove from Brewfile
dot edit              # Open repo in $EDITOR
dot gen-ssh-key       # Generate ed25519 key by email domain
```

## KEY CONFIGS

| Tool | Entry | Notes |
|------|-------|-------|
| Fish | `config.fish` | Minimal, `fish_greeting` disabled |
| Git | `config` | Delta pager, SSH signing, global ignore |
| Mise | `config.toml` | Ruby/Node LTS/bun via latest tags |
| Ghostty | `config` | JetBrains Mono, Catppuccin Macchiato |
| Starship | `starship.toml` | Minimal prompt |

## NOTES

- `fish_variables` is gitignored (auto-generated)
- `dot update` runs `mise install` after stowing
- Backups go to `~/.dotfiles-backups/<timestamp>/`
