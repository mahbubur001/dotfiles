#!/bin/bash
# Fresh-machine bootstrap: Xcode CLT, Homebrew, dotfiles, Brewfile packages, stow.
# Usage: ./install.sh

# Xcode command line tools
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS detected..."

    if xcode-select -p &>/dev/null; then
        echo "Xcode command line tools already installed"
    else
        echo "Installing command line tools..."
        xcode-select --install
        # The installer runs in a GUI dialog and returns immediately
        until xcode-select -p &>/dev/null; do
            read -r -p "Press Enter once the command line tools installer has finished..."
        done
    fi
fi

# Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for the rest of this script (Apple Silicon: /opt/homebrew, Intel: /usr/local)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
brew analytics off

# Clone dotfiles repository (git comes with the command line tools)
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/mahbubur001/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles" || exit

# Packages and apps (see Brewfile)
echo "Installing Brewfile packages..."
brew bundle --file="$HOME/dotfiles/Brewfile"

# Stow dotfiles packages
echo "Stowing dotfiles..."
stow -t ~ git nvim tmux aerospace zsh stow warp lf htop ranger phpcs

# tmux plugin manager (path used by tmux.conf); install plugins with prefix + I
TPM_DIR="$HOME/.config/tmux/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Dotfiles setup complete!"
