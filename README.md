# dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a stow package that mirrors `$HOME`.

## Setup

On a new Mac:

```sh
git clone https://github.com/mahbubur001/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

`install.sh` installs the Xcode command line tools and Homebrew, installs everything in `Brewfile` (`brew bundle`), links the configs with stow, and installs the tmux plugin manager (then press `prefix + I` in tmux to install plugins).

## Usage

```sh
stow -t ~ <package>      # link
stow -D -t ~ <package>   # unlink
stow -R -t ~ <package>   # relink after adding or moving files
```

## Packages

| Package | Config |
|---|---|
| `aerospace` | AeroSpace tiling window manager |
| `git` | `.gitconfig`, global gitignore |
| `htop`, `lf`, `ranger` | CLI tools |
| `nvim` | Neovim (lazy.nvim) |
| `phpcs` | Global PHP_CodeSniffer ruleset |
| `stow` | Stow's global ignore list |
| `tmux` | tmux (plugins via TPM) |
| `warp` | Warp tab configs (settings use Warp Settings Sync) |
| `zsh` | `.zshrc`, aliases, helper scripts |
| `vscode` | PHP config templates (not stowed) |

## Extras

- VS Code extensions: export with `code --list-extensions > vs-extension.txt`, install with `cat vs-extension.txt | xargs -L1 code --install-extension`
- [Mac setup reference](https://github.com/CodingGarden/mac-setup)
- [Unshaky](https://github.com/aahung/Unshaky) — keyboard double-key-press fix
