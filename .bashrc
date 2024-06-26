# .bashrc
export EDITOR=hx
export PATH=$PATH:$HOME/.local/bin:$HOME/fgsm/src:$HOME/repos/bashpy
export XBPS_DISTDIR=$HOME/repos/void-packages
export XBPS_ALLOW_RESTRICTED=yes

#This starts my session manager, FGSM, if it's on tty1 when logged in.

if [[ "$(tty)" == "/dev/tty1" ]]
 then
 fgsm
fi

#Lines 14-38 replace cat with gum write and gum pager.
# Clear the built-in cat command
unalias cat 2>/dev/null
unset -f cat 2>/dev/null

# Define the custom cat function using gum write and gum pager
cat() {
  if [ "$#" -eq 0 ]; then
    gum write
    return
  fi

  if [ "$1" = ">" ] && [ -n "$2" ]; then
    gum write > "$2"
    return
  fi

  for file in "$@"; do
    if [ -f "$file" ]; then
      gum pager < "$file"
    else
      echo "cat: $file: No such file or directory"
    fi
  done
}

#Makes directory and changes into it
function mkcd {
    newDir=$1
    mkdir -p $newDir
    cd $newDir
}

#sets up a python virtual environment
function mkvenv {
    python3 -m venv $1
a   source $1/bin/activate
}

#git commit and push
function gcp {
    git add .
    git commit -m "$1"
    git push
}

#git checkout
function gco {
    git checkout -b $1
}

#Extracting compressed files
function extract {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xvjf $1   ;;
            *.tar.gz)    tar xvzf $1   ;;
            *.bz2)       bunzip2 $1    ;;
            *.rar)       unrar x $1    ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1    ;;
            *.tbz2)      tar xvjf $1   ;;
            *.tgz)       tar xvzf $1   ;;
            *.zip)       unzip $1      ;;
            *.7z)        7z x $1       ;;
            *.Z)         uncompress $1 ;;
            *.xz)        tar xvJf $1   ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#disk usage
function diskusage {
    df -h | grep -E '^Filesystem|/dev/sd|/dev/mapper'
}

#Memory usage
function memusage {
    free -h
}

#FZF-relient functions
#My file finder
ffiles() {
    find . -type f | fzf --preview 'bat --color=always {}' --preview-window=right:60%:wrap
}

#Finds a process/task to kill
fkill() {
    ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

#Finds a directory
fcd() {
    cd "$(find "${1:-.}" -type d | sed 1d | fzf)"
}


#Bash history
fhistory() {
    history | awk '{$1=""; print $0}' | fzf +s --tac | sed 's/^ *//' | bash
}


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#My aliases
alias ls='ls --color=auto'
alias s='source ~/.bashrc'
alias sclear="s && clear"
alias ..='cd ..'          # Go up one directory
alias ...='cd ../..'      # Go up two directories
alias ....='cd ../../..'  # Go up three directories
alias home='cd ~'         # Go to home directory
alias desktop='cd ~/Desktop'  # Go to Desktop directory
alias s="source ~/.bashrc"
alias sclear="clear && s"
alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr' #This does not seem to work with the latest version of TLDR. I am using tealdeer instead and it works with this.
alias bashrcedit="hx ~/.bashrc"
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort" #view mounted drives
alias cpv='rsync -ah --info=progress2'
alias pcmanfm='devour pcmanfm'
alias dolphin='devour dolphin'
alias weather='curl https://wttr.in'
alias wttr='curl https://wttr.in'

#The path
export PATH=$PATH:$HOME/.local/bin

#Activating the direnv, starship, and thefuck programs
eval "$(direnv hook bash)"
# eval "$(starship init bash)"
eval "$(oh-my-posh init bash --config ~/poshthemes/clean-detailed.omp.json)"
eval $(thefuck --alias oops) #Alias for thefuck is "oops"


#This detects if I'm using Zellij. If I'm not, it will run fastfetch. If I am using Zellij, it won't run fastfetch.
if [ -n "$ZELLIJ" ]; then
  clear
else
  fastfetch
fi

#Key bindings
bind '"\C-r": "fhistory\n"' # CTRL + R runs the fhistory function
bind '"\C-k": "fkill\n"'  # CTRL + K runs the fkill function
bind '"\C-f": "ffiles\n"' # CTRL + F runs the ffiles nd function
bind '"\C-b": "bashrcedit\n"' # Runs the bashrcedit alias
