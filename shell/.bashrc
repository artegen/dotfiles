#!/usr/bin/env bash

# Source global configs
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi 2>/dev/null

configs=(exports aliases functions)
for config in "${configs[@]}"; do
    source ~/".$config"
done
unset config configs

# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# Don't let Ctrl-D exit the shell
set -o ignoreeof

# Immediate notification of background job termination
set -o notify

# vim-style keymap
# set -o vi

# generic colouriser
GRC=$(which grc)
if [ "$TERM" != dumb ] && [ -n "$GRC" ]; then
    alias colourify='$GRC -es --colour=auto'
    alias configure='colourify ./configure'
    for app in {diff,make,gcc,g++,ping,traceroute}; do
        alias \$app='colourify $app'
    done
fi

# theme
if [[ -z "$ZSH_VERSION" ]]; then
    eval "$(starship init bash)"

    # Auto-fix minor typos in interactive use of 'cd'
    shopt -s cdspell
    # prepend cd when entering a path in the shell
    shopt -s autocd
    # Autocorrect on directory names to match a glob.
    shopt -s dirspell 2>/dev/null
    # Turn on recursive globbing (enables ** to recurse all directories, e.g. `echo **/*.txt`)
    shopt -s globstar 2>/dev/null
    # Case-insensitive globbing (used in pathname expansion)
    shopt -s nocaseglob 2>/dev/null
fi

# Enable bash completion with sudo
complete -cf sudo

# tab completions
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source /usr/local/etc/profile.d/bash_completion.sh

alias k=kubectl
complete -F __start_kubectl k

# z for cd
zpath="$(brew --prefix)/etc/profile.d/z.sh"
[ -s $zpath ] && source $zpath

# Enable tab completion for `g` by marking it as an alias for `git`, then alias g=git will autocomplete
if type _git &>/dev/null; then
    complete -o default -o nospace -F _git g
fi

# setup dk alias completion
# https://github.com/cykerway/complete-alias
# source "$BASH_COMPLETION_COMPAT_DIR/complete_alias"
# complete -F _complete_alias dk

# hub completion
if which hub >/dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh"
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh 2>/dev/null

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if which pyenv >/dev/null; then
    eval "$(pyenv init -)"
    # eval "$(pyenv virtualenv-init -)"
fi

# Disable homebrew auto update whenever brew command is run
if command -v brew >/dev/null 2>&1; then
    HOMEBREW_NO_AUTO_UPDATE=1
    export HOMEBREW_NO_AUTO_UPDATE
fi

# ssh agent
ssh_env=~/.ssh/agent.env

agent_load_env() { test -f "$ssh_env" && . "$ssh_env" >/dev/null; }

agent_start() {
    (
        umask 077
        ssh-agent >|"$ssh_env"
    )
    . "$ssh_env" >/dev/null
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(
    ssh-add -l >/dev/null 2>&1
    echo $?
)

ssh_state=$agent_run_state
if [ ! "$SSH_AUTH_SOCK" ] || [ "$ssh_state" = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ "$ssh_state" = 1 ]; then
    ssh-add
fi

unset ssh_env ssh_state

# allow mtr to run without sudo
# mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*)//')
# sudo chmod 4755 "$mtrlocation/sbin/mtr"
# sudo chown root "$mtrlocation/sbin/mtr"
