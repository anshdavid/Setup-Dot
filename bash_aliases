# seperate file for aliases, sourced from .bashrc

#python3 alias python2
#alias python=python3

#nvim alias vim
#alias vim=nvim

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias pip=pip3
alias rm='function __rm() { notify-send "STOP! TRY <gio trash> INSTEAD!; unset -f __rm; }; __rm'
#alias rm='function __rm() { notify-send "STOP! TRY <gio trash> INSTEAD! <$*>"; unset -f __rm; }; __rm'
alias updatesystem='sudo apt-get update && sudo apt-get upgrade && sudo apt autoremove'
alias activate='conda activate'
alias deactivate='conda deactivate'
