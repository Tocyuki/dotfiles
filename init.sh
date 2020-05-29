#!/bin/bash
set -eux

if [ $(uname) = "Linux" ]; then
  add-apt-repository -y ppa:lazygit-team/release
  add-apt-repository -y ppa:longsleep/golang-backports
  apt-get update -y
  apt-get install -y golang-go
  apt-get install -y lazygit

  apt-get install -y vim
  apt-get install -y tmux
  apt-get install -y zsh

  if [ ! -d ${HOME}/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
    ${HOME}/.fzf/install
  fi

    go get github.com/x-motemen/ghq
elif [ $(uname) = "Darwin" ]; then
  brew update
  brew install vim
  brew install tmux
  brew install zsh
  brew install go
  brew install fzf
  brew install ghq
  brew install lazygit
  brew install docker
  brew cask install docker
else
  echo "This is unsupported OS!! You can use it only Ubuntu or Mac OSX."
  exit 1
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
chsh -s $(which zsh)

if [ ! -d ${HOME}/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
fi

