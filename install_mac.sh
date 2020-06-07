#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo "=============================="
echo "Update packages"
echo "=============================="
brew update

echo
echo "=============================="
echo "Install powerline fonts"
echo "=============================="
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

echo
echo "=============================="
echo "Install fish & fisher"
echo "=============================="
brew install fish
brew cask install font-inconsolatalgc-nerd-font
brew cask install fonts-powerline
sh ${SCRIPT_DIR}/fish/setup.sh

echo
echo "=============================="
echo "Install vim & tmux"
echo "=============================="
brew install vim
sh ${SCRIPT_DIR}/vim/setup.sh
brew install tmux
sh ${SCRIPT_DIR}/tmux/setup.sh

echo
echo "=============================="
echo "Install Golang"
echo "=============================="
brew install go

echo
echo "=============================="
echo "Install ghq"
echo "=============================="
brew install ghq

echo
echo "=============================="
echo "Install docui"
echo "=============================="
brew tap skanehira/docui
brew install docui

echo
echo "=============================="
echo "Install Lazygit"
echo "=============================="
brew install lazygit

echo
echo "=============================="
echo "Install ag & fzf"
echo "=============================="
brew install ag
brew install fzf

