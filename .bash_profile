# include .bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# OPAM configuration
[[ -f ~/.opam/opam-init/init.sh ]] && . ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null
