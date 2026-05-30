autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='ls --color=auto'
alias grep='grep --color=auto'

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete
bindkey '^[[3~' delete-char

# Page Up / Page Down
bindkey '^[[5~' beginning-of-history
bindkey '^[[6~' end-of-history

# Colore username diverso per root
if [[ $EUID -eq 0 ]]; then
    USER_COLOR='%F{196}'
    SYMBOL='#'
else
    USER_COLOR='%F{251}'
    SYMBOL='$'
fi

PROMPT='[%F{39}%D{%d-%m-%Y}%f %F{111}%*%f] '"${USER_COLOR}"'%n%f@%F{251}%M%f %F{194}%~%f
%F{157}'"${SYMBOL}"'%f: '

ta() {
    if [[ -z "$1" ]]; then
        tmux attach
    else
        tmux attach -t "$1" 2>/dev/null || tmux new -s "$1"
    fi
}

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.history

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
