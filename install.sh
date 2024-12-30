#!/bin/bash
# Prepare install file and run
# % chmod 755 install.sh
#./install.sh

# Install xCode cli tools
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS deteted..."

    if xcode-select -p &>/dev/null; then
        echo "Xcode already installed"
    else
        echo "Installing commandline tools..."
        xcode-select --install
    fi
fi

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off


## Formulae
echo "Installing Brew Formulae..."
### Must Have things
brew install zsh-autosuggestions
brew install zsh-autocomplete
brew install zsh-syntax-highlighting
brew install stow
brew install fzf
brew install bat #bat supports syntax highlighting for a large number of programming and markup languages: https://github.com/sharkdp/bat?tab=readme-ov-file
brew install fd #https://github.com/sharkdp/fd
brew install zoxide #https://github.com/ajeetdsouza/zoxide
brew install --cask ghostty

### Terminal
brew install git
brew install lazygit
brew install tmux
brew install neovim
brew install starship #https://github.com/starship/starship
#brew install tree-sitter
brew install tree #tree view of folder
#brew install borders
brew install stats
brew install --cask appcleaner


### dev things
brew install node
brew install nvm
brew install sqlite



## Casks
brew install --cask google-chrome
brew install --cask alfred
brew install --cask amethyst
brew install --cask alt-tab
brew install --cask skype
brew install --cask tableplus
brew install --cask local

brew install --cask raycast #https://github.com/raycast
brew install --cask wezterm
brew install --cask nikitabobko/tap/aerospace # windowmanager https://www.josean.com/posts/how-to-setup-aerospace-tiling-window-manager
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
#brew install --cask karabiner-elements #https://karabiner-elements.pqrs.org/
#brew install --cask keycastr #https://github.com/keycastr/keycastr
#brew install --cask betterdisplay #https://github.com/waydabber/BetterDisplay
#brew install --cask linearmouse #https://linearmouse.app/
#brew install --cask font-sf-pro


csrutil status
echo "Installation complete..."

# Clone dotfiles repository
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/mahbubur001/dotfiles.git $HOME/dotfiles
fi

# Navigate to dotfiles directory
cd $HOME/dotfiles || exit

# Stow dotfiles packages
echo "Stowing dotfiles..."
stow -t ~ git nvim tmux starship aerospace karabiner neovim wezterm zsh stow

echo "Dotfiles setup complete!"

## Applications
brew install zsh

#App Cleaner
# https://freemacsoft.net/appcleaner/
