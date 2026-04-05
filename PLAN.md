# Dotfiles Bootstrap Plan

## Goal

Build a personal `dot` CLI for `~/.dotfiles` that manages a small, reliable macOS bootstrap flow with GNU Stow and Homebrew.

## V1 Scope

- Platform: macOS only
- Repo path: `~/.dotfiles`
- Implementation: single Bash script
- Commands:
  - `init`
  - `stow`
  - `doctor`
  - `update`
  - `link`
  - `unlink`
  - `help`

## Repo Layout

```text
~/.dotfiles/
├── dot
├── Brewfile
├── home/
└── README.md
```

## UX Decisions

- Use plain Bash prompts and output
- `help` must work before `init`
- `link` must work before `init`
- Prompt before major actions by default
- Support `--yes` to skip confirmations
- Keep output polished, but do not add heavy internal abstractions

## Preflight

Only `init` runs preflight.

Preflight responsibilities:

1. Ensure Homebrew is installed
2. Ensure `stow` is installed

Notes:

- Homebrew install should be prompted first, then run non-interactively after approval
- `stow` should be special-cased in preflight and also declared in `Brewfile`

## Command Behavior

### `dot init`

1. Run preflight
2. Prompt before major actions unless `--yes`
3. Run `brew bundle --file ~/.dotfiles/Brewfile`
4. If bundle fails, stop immediately
5. If `fish` exists, apply Fish default-shell setup
6. Run `stow`
7. `stow` should run `mise install` as a side effect after linking files

Fish default-shell setup should copy the dmmulroy behavior closely:

1. Confirm `fish` exists
2. Resolve the Fish binary path
3. Add the Fish path to `/etc/shells` if missing
4. If `$SHELL` is not Fish, run `chsh -s <fish-path>`
5. If Fish is already the default shell, do nothing
6. If changing the shell fails, warn and continue

Notes:

- This step is part of `init`
- Do not install Fisher or Fish plugins in v1
- Fish default-shell setup should not be a fatal error

### `dot stow`

- Stow all of `~/.dotfiles/home`
- Fail loudly on conflicts
- Support `--dry-run`
- On non-dry-run, run `mise install` after stowing managed files
- No automatic overwrite behavior
- No automatic backup mode in normal operation

### `dot doctor`

Treat these as failures:

- Missing `~/.dotfiles/home`
- Missing `~/.dotfiles/Brewfile`
- Missing `brew`
- Missing `stow`
- Missing Brewfile packages via `brew bundle check --file ~/.dotfiles/Brewfile`
- Broken managed symlinks
- Managed targets that exist as regular files instead of symlinks

Doctor should:

- Derive managed targets dynamically from `home/`
- Only inspect symlinks/targets owned by this dotfiles repo
- Avoid command-reference linting for shell aliases in v1

### `dot update`

1. Warn if the repo is dirty
2. Confirm whether to continue if dirty unless `--yes`
3. Run plain `git pull`
4. Prompt separately before package updates unless `--yes`
5. Run:
   - `brew update`
   - `brew upgrade`
   - `brew bundle --file ~/.dotfiles/Brewfile`
6. Prompt separately before re-stowing unless `--yes`
7. Run `stow`
8. `stow` should run `mise install` as a side effect after linking files

### `dot link`

Behavior:

1. `mkdir -p ~/.local/bin`
2. If `~/.local/bin/dot` is a symlink, remove it
3. Create symlink to `~/.dotfiles/dot`
4. Fail if symlink creation fails

### `dot unlink`

- Remove the `~/.local/bin/dot` symlink if present
- Do not delete non-symlink files

### `dot help`

- Must work before `init`
- Use plain shell output

## Managed Configs For First Migration

Include:

- `~/.config/fish/...`
- `~/.config/gh/...`
- `~/.config/git/...`
- `~/.config/ghostty/config`
- `~/.config/mise/...`
- `~/.config/opencode/...`
- `~/.config/starship.toml`

Exclude:

- `~/.config/fish/fish_variables`
- zsh files
- identity automation
- AI helper commands
- package add/remove/list UX

## Migration Policy

- Apply-only model: repo is curated manually; `dot` applies it
- First migration should back up existing live files before stowing
- Backup path: `~/.dotfiles-backups/<timestamp>/...`
- Backup behavior is one-time migration support, not routine `stow` behavior
- Curate files before copying into `home/`

## Git Config Decisions

- Manage `~/.config/git/...`, not `~/.gitconfig`, in v1
- Keep public identity in managed git config
- Keep the existing `amend` alias as-is

## Fish Config Decisions

- Keep existing aliases even if some commands are not installed by the first Brewfile
- Keep `pnpm.fish`
- Exclude `fish_variables`
- Let Stow manage the whole Fish tree; ignore `fish_variables` in Git

## First Brewfile

Minimal baseline:

- `1password`
- `1password-cli`
- `cleanshot`
- `cursor`
- `eza`
- `fish`
- `font-inter`
- `font-jetbrains-mono-nerd-font`
- `gh`
- `git`
- `gnupg`
- `starship`
- `fzf`
- `ghostty`
- `github`
- `helium-browser`
- `jq`
- `kitlangton-hex`
- `libpq`
- `libyaml`
- `mise`
- `orbstack`
- `raycast`
- `ripgrep`
- `stow`
- `tailscale-app`
- `zoxide`

## Implementation Order

1. Scaffold repo structure
2. Write `README.md`
3. Create `Brewfile`
4. Write first version of `dot`
5. Back up current live configs to `~/.dotfiles-backups/<timestamp>/`
6. Migrate curated config files into `home/`
7. Test `link`, `help`, `init`, `doctor`, `stow --dry-run`
