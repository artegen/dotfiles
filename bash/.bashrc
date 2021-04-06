#!/usr/bin/env bash

#Load the shell dotfiles
#~/.config/.local can be used for settings you don’t want to commit,
for file in ~/.{bash_prompt,exports,aliases,functions,docker_aliases,config/.local}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# Better cd
# Autocorrect on directory names to match a glob.
shopt -s dirspell 2>/dev/null
# Turn on recursive globbing (enables ** to recurse all directories, e.g. `echo **/*.txt`)
shopt -s globstar 2>/dev/null
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob 2>/dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2>/dev/null

# generic colouriser
GRC=$(which grc)
if [ "$TERM" != dumb ] && [ -n "$GRC" ]; then
    alias colourify='$GRC -es --colour=auto'
    alias configure='colourify ./configure'
    for app in {diff,make,gcc,g++,ping,traceroute}; do
        alias $app='colourify $app'
    done
fi

# theme
if [[ -z "$ZSH_VERSION" ]]; then
    eval "$(starship init bash)"
fi

# z for cd. `brew install z`
zpath="$(brew --prefix)/etc/profile.d/z.sh"
[ -s $zpath ] && source $zpath

# allow mtr to run without sudo
# mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*)//')
# sudo chmod 4755 "$mtrlocation/sbin/mtr"
# sudo chown root "$mtrlocation/sbin/mtr"

# Enable tab completion for `g` by marking it as an alias for `git`, then alias g=git will autocomplete
if type _git &>/dev/null; then
    complete -o default -o nospace -F _git g
fi

# Add tab completion for many Bash commands
if which brew &>/dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# setup dk alias completion
# https://github.com/cykerway/complete-alias
# source "$BASH_COMPLETION_COMPAT_DIR/complete_alias"
# complete -F _complete_alias dk

# # hub completion
if which hub >/dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh"
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh 2>/dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
