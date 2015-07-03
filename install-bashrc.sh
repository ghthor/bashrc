#!/bin/sh

ln -s "$1/profile"      $HOME/.profile
ln -s "$1/bash_profile" $HOME/.bash_profile
ln -s "$1/bashrc"       $HOME/.bashrc
ln -s "$1/bash_aliases" $HOME/.bash_aliases
ln -s "$1/bash_funcs"   $HOME/.bash_funcs
ln -s "$1/inputrc"      $HOME/.inputrc
