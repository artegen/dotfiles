# uncomment to profile prompt startup with zprof
# zmodload zsh/zprof
# see below for stop command

ZDOTDIR="$HOME/.dotfiles/zsh"

source "$ZDOTDIR/antigen/antigen.zsh"

# zstyle :omz:plugins:ssh-agent agent-forwarding on
# zstyle :omz:plugins:ssh-agent $(ls -1 ~/.ssh/id_* | grep -Ev '\.pub$' | xargs -n 1 basename | paste -sd ' ' -)

antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
  autojump
  colored-man-pages
  command-not-found
  gitfast
  ssh-agent
  taskwarrior
  mafredri/zsh-async
  hcgraf/zsh-sudo
  hlissner/zsh-autopair
  Tarrasch/zsh-bd
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zdharma/fast-syntax-highlighting
EOBUNDLES
antigen apply

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

zle -N edit-command-line
bindkey "^E" edit-command-line

source ~/.bashrc

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "$HOME/.bash_profile" ]]; then
  source "$HOME/.bashrc"
fi

# theme
eval "$(starship init zsh)"

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1

# Set proper TERM for tmux
if [ -n "$TMUX" ]; then
  export TERM=tmux-256color
else
  export TERM=xterm-256color
fi

[ -f ~/.completion.zsh ] && source ~/.completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# Reload the plugin to highlight the commands each time Iterm2 starts
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# [[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Enable command correction
setopt CORRECT

# Cd shortcut
setopt AUTO_CD

# Dots expansion
setopt GLOB_DOTS

# Extended glob operator
setopt EXTENDED_GLOB

# Add overwrite warnings
unsetopt CLOBBER

# Pipe to multiple files
setopt MULTIOS

# Easy URL copy-pasting.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Expansion options
setopt BRACE_CCL
setopt COMBINING_CHARS
setopt RC_QUOTES

# Job control
setopt LONG_LIST_JOBS
setopt AUTO_RESUME
setopt NOTIFY
unsetopt BG_NICE
unsetopt HUP
unsetopt CHECK_JOBS

# directory options
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# History file path.
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"
# Internal history max size.
HISTSIZE=2000
# History file max size
SAVEHIST=2000

setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY            # Don't execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing nonexistent history.

# # uncomment to finish profiling
# # zprof

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
