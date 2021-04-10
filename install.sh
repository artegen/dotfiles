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

    for dir in "$WDIR/shell" "$WDIR/git" "$WDIR/configs"; do
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
        # ["code/settings.json"]=".config/Code/User/settings.json"
    )
    for file in "${!files[@]}"; do
        link "$(pwd)/${file}" "$HOME/${files[${file}]}"
    done
}

symlink_dotfiles

if test ! "$(which brew)"; then
    log "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew tap Homebrew/bundle
log "Installing brew packages"
brew bundle

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
