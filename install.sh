#!/bin/sh

cd ..
stow -t ~/ --ignore=.git/ --ignore=install.sh bash/
