# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

macOS dotfiles managed with **GNU Stow**. Each top-level directory is a stow package whose contents mirror `$HOME`; files are symlinked into place, so the files in this repo are the live configs. Edits here take effect immediately (e.g. `~/.config/nvim -> ../dotfiles/nvim/.config/nvim`, `~/.zshrc -> dotfiles/zsh/.zshrc`).

## Commands

- Link a package: `stow -t ~ <package>` (run from repo root). Unlink: `stow -D -t ~ <package>`. Re-link after adding/moving files: `stow -R -t ~ <package>`.
- Adding a new config: create `<package>/<path relative to $HOME>` (e.g. `foo/.config/foo/config`), then stow it. Moving an existing real file into the repo requires removing the original first or stow will refuse with a conflict.
- `install.sh` is a fresh-machine bootstrap (Xcode CLT, Homebrew, clone, `brew bundle` from `Brewfile`, stow, TPM). Add new packages/apps to `Brewfile`, not `install.sh`; `brew bundle check --file Brewfile` shows what's missing. It runs non-idempotent installers; don't run it to test a change.
- Reload: tmux `prefix r` (sources `~/.config/tmux/tmux.conf`); zsh `exec zsh`; Neovim changes via lazy.nvim `:Lazy`.
- There are no builds, tests, or linters for the repo itself. For Lua, `stylua` is the formatter (via conform.nvim).

## Layout notes

- `stow/.stow-global-ignore` is itself stowed to `~/.stow-global-ignore` and controls what stow skips. Its presence replaces stow's built-in default ignore list, so it re-lists those defaults (`.git`, `README.*`, `LICENSE.*`, ...); keep that in mind when adding entries.
- `.gitignore` excludes `nvim/.config/nvim/lazy-lock.json`, nvim `sessions/`, `plugin/`, and tmux `plugins/` (TPM-managed, installed to `~/.config/tmux/.tmux/plugins/tpm`).
- `git/.gitignore_global` is the global git excludes file (wired via `core.excludesfile` in `git/.gitconfig`).
- `zsh/.config/zsh/` is on `$PATH` (set in `.zshrc`), so scripts there (e.g. `tmux-sessionizer`, bound to tmux `prefix f`) are callable directly. Aliases live in `aliases.zsh`.
- `phpcs/` is the global PHP_CodeSniffer ruleset (stowed). `vscode/.vscode/` holds per-project PHP templates (phpcs.xml, .php-cs-fixer.php) and is intentionally not stowed.

## Neovim (`nvim/.config/nvim`)

- `init.lua` loads `config.keymaps`, `config.options`, `config.autocmds`, `config.abbreviations`, then `config.lazy`.
- `config/lazy.lua` bootstraps lazy.nvim and imports every file in `lua/plugins/` as a spec (`{ import = "plugins" }`) — add a plugin by dropping a new file returning a spec table there.
- **Dev mode**: lazy's `dev.path = "~/dev"` with `fallback = true`. Plugins marked `dev = true` load from `~/dev/<name>` if present, else GitHub. `plugins/iremote.lua` uses this for `mahbubur001/iremote` (the user's own deployment plugin, sharing `.vscode/iremote.json` with the VS Code extension); its keys are under `<leader>d*`.
- LSP: `plugins/lsp.lua` sets up mason + mason-lspconfig; server configs come from `plugins/lsp/servers.lua` (its keys are also the mason `ensure_installed` list). LSP keymaps are set in an `LspAttach` autocmd using telescope pickers.
- Formatting/linting: `plugins/formatting.lua` (conform.nvim + nvim-lint, replaced none-ls). Format-on-save is toggled by `vim.g.autoformat` (`<leader>uf`).
- which-key group definitions live in `config/which-key/`.
- Commit messages in this repo are prefixed by area, e.g. `nvim: ...`, `git: ...`.
