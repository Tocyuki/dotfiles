#!/bin/bash

readonly SCRIPT_DIR=$(cd $(dirname $0); pwd)

# brew install python2
# pip install pynvim
# pip3 install pynvim
# gem install neovim
# npm -g install neovim


dotfiles='.zshrc .zshenv .vimrc .tmux.conf .gitconfig'

for dotfile in $(echo $dotfiles)
do
  if [ -e $HOME/$dotfile ]; then
    rm -f $HOME/$dotfile
  fi
  ln -s $SCRIPT_DIR/$dotfile $HOME/$dotfile
done
