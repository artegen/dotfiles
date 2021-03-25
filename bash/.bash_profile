#!/usr/bin/env bash
# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/config/.local can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
for file in ~/.{bash_prompt,exports,aliases,functions,docker_aliases,config/.local}; do
    [ -r "$file" ] && source "$file"
done
unset file



# Do not override files using `>`, but it's still possible using `>!`
set -o noclobber

# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        for app in {diff,make,gcc,g++,ping,traceroute}; do
            alias "$app"='colourify '$app
    done
fi



##
## Tab Completion…
##

# z beats cd most of the time. `brew install z`
zpath="$(brew --prefix)/etc/profile.d/z.sh"
[ -s $zpath ] && source $zpath

# Enable tab completion for `g` by marking it as an alias for `git`, then alias g=git will autocomplete
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;


# The below applies only for bash, so exit if in zsh
if [[ -n "$ZSH_VERSION" ]]; then
    return 1 2> /dev/null || exit 1;
fi;

# bash completion
if  which brew > /dev/null
    && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# homebrew completion
# if  which brew > /dev/null; then
#     source "$(brew --prefix)/etc/bash_completion.d/brew"
# fi;

# hub completion
if  which hub > /dev/null; then
    source "$(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh";
fi;

# Add tab completion for SSH hostnames based on ~/.ssh.config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


##
## better `cd`'ing in bash
##

# Autocorrect on directory names to match a glob.
shopt -s dirspell 2> /dev/null

# Turn on recursive globbing (enables ** to recurse all directories, e.g. `echo **/*.txt`)
shopt -s globstar 2> /dev/null

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell;

# added by Anaconda3 2019.07 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Applications/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/Applications/anaconda3/etc/profile.d/conda.sh" ]; then
# . "/Applications/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/Applications/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Applications/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Applications/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Applications/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Applications/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

