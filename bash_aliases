#!/bin/bash
alias ls='ls --color'
alias l='ls -l'
alias l..='(cd ..; ls -l)'
alias ll='ls -l'
alias ll..='(cd ..; ll)'
alias lla='ls -l -a'
alias pfind='ps aux | grep $1'
alias vit='vim $HOME/.tmp/temp'
alias vrc='vim $HOME/.vimrc'

alias open='xdg-open'
alias pyhttp='python -m http.server 8000'

# Git Quickies
alias gitexport='git daemon --base-path=$PWD/../ --verbose --export-all'
alias gtree='git-forest --sha -n20'
alias gfresh='g reset --hard HEAD && git clean -f -d'

# keychain
alias kch='eval $(keychain --eval --agents ssh -Q --quiet $HOME/.ssh/id_rsa)'

# Golang Quickies
alias godoc='godoc -goroot=/usr/lib/go -http=":6060"'
