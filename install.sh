#!/bin/bash
# Fresh-machine bootstrap: Xcode CLT, Homebrew + packages, dotfiles, stow.
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

## Formulae
echo "Installing Brew formulae..."
### Shell
brew install zsh
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install stow
brew install fzf
brew install bat    # https://github.com/sharkdp/bat
brew install fd     # https://github.com/sharkdp/fd
brew install eza    # fzf directory previews in .zshrc
brew install zoxide # https://github.com/ajeetdsouza/zoxide

### Terminal
brew install git
brew install lazygit
brew install tmux
brew install neovim
brew install tree
brew install lf
brew install ranger
brew install htop

### Dev
brew install node
brew install nvm
brew install sqlite

## Casks
echo "Installing Brew casks..."
brew install --cask warp
brew install --cask stats
brew install --cask appcleaner # https://freemacsoft.net/appcleaner/
brew install --cask google-chrome
brew install --cask alfred
brew install --cask alt-tab
brew install --cask microsoft-teams
brew install --cask tableplus
brew install --cask local
brew install --cask betterdisplay
brew install --cask raycast
brew install --cask nikitabobko/tap/aerospace # https://www.josean.com/posts/how-to-setup-aerospace-tiling-window-manager
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font

# Clone dotfiles repository
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/mahbubur001/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles" || exit

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
