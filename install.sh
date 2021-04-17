#!/usr/bin/env bash

log() { echo -e "\n \033[1;33m➜\033[0m  $* \n"; }
success() { echo -e "\n \033[1;32m✔\033[0m  $* \n"; }

link() {
    file=$1
    link=$2

    # mkdir -p "$(dirname "${link}")"
    ln -vf -s "${file}" "${link}"
}

symlink_dotfiles() {
    log 'Symlinking dotfiles'
    WDIR="$HOME/.dotfiles"

    for dir in "$WDIR/shell" "$WDIR/git" "$WDIR/configs" "$WDIR/zsh"; do
        for file in "$dir"/.*; do
            base="$(basename "$file")"
            [[ $base =~ ^(.|..|.DS_Store)$ ]] && continue # skip these files
            dest="$HOME/$base"
            link "$file" "$dest"
        done
    done

    mkdir "$HOME"/.ssh{,/control}
    declare -A files
    files=(
        ["configs/ssh"]=".ssh/config"
    )
    for file in "${!files[@]}"; do
        link "$(pwd)/${file}" "$HOME/${files[${file}]}"
    done
}

log "Installing Oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

symlink_dotfiles

mkdir -p "$HOME"/.{config,cache,local/share} && cd "$HOME/.config" && touch .gitconfig.local

# Install OS dependencies, full Xcode, not just git/CLI tools
log "Checking Xcode install"
xcode-select --install 2>&1 | grep installed >/dev/null
if [[ $? ]]; then
    log "Installing Xcode"
    xcode-select --install
    log "Press a key after Xcode has been installed to continue..."
else
    log "Xcode already installed"
fi

if test ! "$(which brew)"; then
    log "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

brew tap Homebrew/bundle
log "Installing brew packages"
brew bundle
brew doctor # all setup correctly?

# Change shell for the root user, ex. `sh script.sh` uses it
BREW_BASH_PATH=$(which -a bash | head -n 1)
if grep -Fxq "/etc/shells" "$BREW_BASH_PATH"; then
    echo "latest homebrew bash version already configured"
else
    echo "$BREW_BASH_PATH" | sudo tee -a /etc/shells
    sudo chsh -s "$BREW_BASH_PATH"
fi

log "Setting up mac OS"
bash ./configs/macos.sh

log "Installing more packages"
# syntax highlighted cat, alias catc
pip3 install Pygments
#Install antigen
git clone --recursive https://github.com/zsh-users/antigen.git "$HOME/.dotfiles/zsh/antigen"
# change nvm version ↓. Todo: use script for "manual" install
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash
curl -o- -L https://yarnpkg.com/install.sh | bash

success 'All installed!'
exit 0
