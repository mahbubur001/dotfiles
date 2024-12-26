# System
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'
alias c='clear'
alias e='exit'
alias o='open .'

#
# Git and LazyGit
# ------------------------------------------------------------------------------
## Aliases
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gf='git fetch'
alias gs='git status -s'
alias gss='git status -s'
alias gst="git status"
alias gci="git commit"
alias gp="git push"
alias gfa="git fetch --all"

# Function to commit with ticket ID from current branch, with optional push
quick_commit() {
  local branch_name ticket_id commit_message push_flag
  branch_name=$(git branch --show-current)
  ticket_id=$(echo "$branch_name" | awk -F '-' '{print toupper($1"-"$2)}')
  commit_message="$ticket_id: $*"
  push_flag=$1

  if [[ "$push_flag" == "push" ]]; then
    # Remove 'push' from the commit message
    commit_message="$ticket_id: ${*:2}" # take all positional parameters starting from the second one
    git commit --no-verify -m "$commit_message" && git push
  else
    git commit --no-verify -m "$commit_message"
  fi
}

alias gqc='quick_commit'
alias gqcp='quick_commit push'


# Folders
alias doc="$HOME/Documents"
alias dow="$HOME/Downloads"

# Ranger
alias r=". ranger"


# eza (better `ls`)
# ------------------------------------------------------------------------------
if type eza &>/dev/null; then
  alias l="eza --icons"
  alias ls="eza --icons"
  alias ll="eza -lg --icons"
  alias la="eza -lag --icons"
  alias lt="eza -lTg --icons"
  alias lt1="eza -lTg --level=1 --icons"
  alias lt2="eza -lTg --level=2 --icons"
  alias lt3="eza -lTg --level=3 --icons"
  alias lta="eza -lTag --icons"
  alias lta1="eza -lTag --level=1 --icons"
  alias lta2="eza -lTag --level=2 --icons"
  alias lta3="eza -lTag --level=3 --icons"
fi

# Other aliases
# ------------------------------------------------------------------------------
alias vim="nvim"
alias vi="nvim"
alias n="nvim"

# Lazygit
alias lg="lazygit"

#svn
alias svnadd="svn st | awk '/\?/ {print $2}' | xargs svn add"
alias svnrm="svn st | awk '/\!/ {print $2}' | xargs svn rm --force"
