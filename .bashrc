# .bashrc

export PATH=$PATH:$HOME/.local/bin:$HOME/fgsm/src:$HOME/repos/bashpy
export XBPS_DISTDIR=$HOME/repos/void-packages
export XBPS_ALLOW_RESTRICTED=yes

if [[ "$(tty)" == "/dev/tty1" ]]
 then
 fgsm
fi

function mkcd {
  newDir=$1
  mkdir $newDir
  cd $newDir
}

function mkcd {
    mkdir -p "$1" && cd "$1"    # Create a directory and move into it
}

function extract {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xvjf $1 ;;
            *.tar.gz) tar xvzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xvf $1 ;;
            *.tbz2) tar xvjf $1 ;;
            *.tgz) tar xvzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

ffiles() {
    find . -type f | fzf --preview 'bat --color=always {}' --preview-window=right:60%:wrap
}

fkill() {
    ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

fcd() {
    cd "$(find "${1:-.}" -type d | sed 1d | fzf)"
}

fhistory() {
    history | awk '{$1=""; print $0}' | fzf +s --tac | sed 's/^ *//' | bash
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ '
alias s='source ~/.bashrc'
alias sclear="s && clear"
alias ..='cd ..'          # Go up one directory
alias ...='cd ../..'      # Go up two directories
alias ....='cd ../../..'  # Go up three directories
alias home='cd ~'         # Go to home directory
alias desktop='cd ~/Desktop'  # Go to Desktop directory

export PATH=$PATH:$HOME/.local/bin

eval "$(direnv hook bash)"
eval "$(starship init bash)"
eval $(thefuck --alias oops)


alias s="source ~/.bashrc"
alias sclear="clear && s"
alias ls="eza"

if [ -n "$ZELLIJ" ]; then
  clear
else
  # ufetch
  fastfetch
fi

bind '"\C-r": "fhistory\n"'
bind '"\C-k": "fkill\n"'
bind '\C-f": "ffiles\n"'
