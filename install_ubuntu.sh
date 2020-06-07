#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo "=============================="
echo "Update packages"
echo "=============================="
apt-get update -y

echo
echo "=============================="
echo "Install powerline fonts"
echo "=============================="
apt-get install -y fonts-powerline

echo
echo "=============================="
echo "Install fish & fisher"
echo "=============================="
apt-add-repository -y ppa:fish-shell/release-3
apt-get install -y fish
sh ${SCRIPT_DIR}/fish/setup.sh

echo
echo "=============================="
echo "Install Golang"
echo "=============================="
export GOPATH=${HOME}/go
add-apt-repository -y ppa:longsleep/golang-backports
apt-get install -y golang-go

echo
echo "=============================="
echo "Install ghq"
echo "=============================="
go get github.com/x-motemen/ghq
echo "Finished install ghq !!"

echo
echo "=============================="
echo "Install docui"
echo "=============================="
go get -d github.com/skanehira/docui
cd ${GOPATH}/src/github.com/skanehira/docui
echo "Finished install docui !!"

echo
echo "=============================="
echo "Install Lazygit"
echo "=============================="
add-apt-repository -y ppa:lazygit-team/release
apt-get install -y lazygit

echo
echo "=============================="
echo "Install ag & fzf"
echo "=============================="
apt-get install -y silversearcher-ag
if [ ! -d ${HOME}/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
  ${HOME}/.fzf/install
fi
echo "Finished install ag & fzf !!"

echo
echo "=============================="
echo "Install vim & tmux"
echo "=============================="
apt-get install -y vim
sh ${SCRIPT_DIR}/vim/setup.sh
apt-get install -y tmux
sh ${SCRIPT_DIR}/tmux/setup.sh

