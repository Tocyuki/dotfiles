#!/bin/bash

# brew install zsh
# brew install zplug
# brew install neovim
# brew install python2
# pip install pynvim
# pip3 install pynvim
# gem install neovim
# npm -g install neovim


readonly SCRIPT_DIR=$(cd $(dirname $0); pwd)
readonly dotfiles='.zshrc .zshenv .vimrc .tmux.conf .gitconfig .config'

for dotfile in $(echo $dotfiles)
do
  if [ -e $HOME/$dotfile ]; then
    rm -rf $HOME/$dotfile
  fi
  ln -s $SCRIPT_DIR/$dotfile $HOME/$dotfile
done

