#------------------------------------------------------------------#
# File: .zshrc ZSH resource file #
# Version: 0.1.1 #
# Author: Mike Pretzlaw <pretzlaw@gmail.com> #
#------------------------------------------------------------------#

#------------------------------
# History stuff
#------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#------------------------------
# Variables
#------------------------------
export BROWSER="firefox"
export EDITOR="nano"
export PAGER="less"
export PATH="${PATH}:${HOME}/bin"

#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

#------------------------------
# Keybindings
#------------------------------

insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo

bindkey -v
typeset -g -A key
#bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
#bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# ALT S
bindkey "^O" insert-sudo

#------------------------------
# Alias stuff
#------------------------------
alias ls="ls --color -F"
alias ll="ls --color -lh"

urlencode() {
  echo -n $* | od -A n -t x1 | sed 's/ /\%/g'
}

# Search google for the given keywords.
function google {
        $BROWSER "http://www.google.com/search?q=$( urlencode $* )"
}

#------------------------------
# Comp stuff
#------------------------------
zmodload zsh/complist
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'

# Faster! (?)
#zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete
zstyle ':completion:*' completer _expand _complete _approximate _ignored

zstyle ':completion:*:default' menu select=0
setopt menu_complete

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

#- buggy
#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
##-/buggy
#
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#
#zstyle ':completion:*:*:kill:*' menu yes select
#zstyle ':completion:*:kill:*' force-list always
#
#zstyle ':completion:*:*:killall:*' menu yes select
#zstyle ':completion:*:killall:*' force-list always

#------------------------------
# Window title
#------------------------------
case $TERM in
    termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
precmd () { print -Pn "\e]0;[%n@%M][%~]%#\a" }
preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
;;
    screen)
    precmd () {
        print -Pn "\e]83;title \"$1\"\a"
        print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
    }
    preexec () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
    }
;;
esac

#------------------------------
# Prompt
#------------------------------
setprompt () {
    # load some modules
    autoload -U colors zsh/terminfo # Used in the colour alias below
    colors
    setopt prompt_subst
    
    # make some aliases for the colours: (coud use normal escap.seq's too)
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$fg[${(L)color}]%}'
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
    
    # Check the UID
    if [[ $UID -ge 1000 ]]; then # normal user
    eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
    eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
    elif [[ $UID -eq 0 ]]; then # root
    eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
    eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
    fi	
    
    # Check if we are on SSH or not
    if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    eval PR_HOST='${PR_RED}%M${PR_NO_COLOR}' #SSH
    else
    eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
    fi
    # set the prompt
    PS1=$'${PR_}${PR_USER}@${PR_HOST}:%~${PR_USER_OP} '
    PS2=$'%_>'
}
setprompt

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.shell_aliases ]; then
    . ~/.shell_aliases
fi

if [ -f ~/.shell_aliases_cx ]; then
    . ~/.shell_aliases_cx
fi

if [ -f ~/.shell_aliases_rmp ]; then
    . ~/.shell_aliases_rmp
fi