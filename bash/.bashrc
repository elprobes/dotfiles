#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Colore username diverso per root
if [[ $EUID -eq 0 ]]; then
    USER_COLOR='\[\e[38;5;196m\]'
    SYMBOL='#'
else
    USER_COLOR='\[\e[38;5;251m\]'
    SYMBOL='$'
fi

PS1='[\[\e[38;5;39m\]\D{%d-%m-%Y}\[\e[0m\] \[\e[38;5;111m\]\t\[\e[0m\]] '"$USER_COLOR"'\u\[\e[0m\]@\[\e[38;5;251;2m\]\H\[\e[0m\] \[\e[38;5;194;3m\]\w\n\[\e[0;38;5;157m\]'"$SYMBOL"'\[\e[0m\]: '

#export EDITOR="nvim"
#export VISUAL="nvim"
# For sudo users
#export SUDO_EDITOR="nvim"

ta () {
    if [ -z "$1" ]; then
        tmux attach
    else
        tmux attach -t "$1" 2>/dev/null || tmux new -s "$1"
    fi
}

HISTFILE="$HOME/.history"

HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend

PROMPT_COMMAND='history -a; history -n'
