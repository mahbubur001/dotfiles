#!/usr/bin/env zsh

# Brew
#eval "$(brew shellenv)"
if [[ -e "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
  export HOMEBREW_NO_AUTO_UPDATE=1
fi
if [[ -e "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Add local ~/scripts to the PATH
export PATH="$HOME/.config/zsh:$PATH"

export TMUX_CONF=~/.config/tmux/tmux.conf

# Starship
eval "$(starship init zsh)"
# set Starship PATH
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml


# NOTE: Zoxide
eval "$(zoxide init zsh)"

# NOTE: FZF
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "

# FZF with Git right in the shell by Junegunn : check out his github below
# Keymaps for this is available at https://github.com/junegunn/fzf-git.sh
[ -f "$HOME/.config/zsh/fzf-git.sh" ] && source $HOME/.config/zsh/fzf-git.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8


# brew installations activation (new mac systems brew path: opt/homebrew , not usr/local )
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Aliases
[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"
export PATH="/usr/local/opt/node@20/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/mahbubur/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
