#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

function decoration() {
  echo
  echo "=============================="
  echo $text
  echo "=============================="
}

OS_TYPE=$(uname -s)

text="Update packages"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew update
elif [ $OS_TYPE == "Linux" ]; then
  apt-get update -y
fi

text="Install powerline fonts"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts
elif [ $OS_TYPE == "Linux" ]; then
  apt-get install -y fonts-powerline
fi

text="Install fish & fisher"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew install fish
elif [ $OS_TYPE == "Linux" ]; then
  apt-add-repository -y ppa:fish-shell/release-3
  apt-get install -y fish
fi
sh ${SCRIPT_DIR}/fish/setup.sh

text="Install Golang"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew install go
elif [ $OS_TYPE == "Linux" ]; then
  export GOPATH=${HOME}/go
  add-apt-repository -y ppa:longsleep/golang-backports
  apt-get install -y golang-go
fi

text="Install ghq"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew install ghq
elif [ $OS_TYPE == "Linux" ]; then
  go get github.com/x-motemen/ghq
fi
echo "Finished install ghq !!"

text="Install docui"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew tap skanehira/docui
  brew install docui
elif [ $OS_TYPE == "Linux" ]; then
  go get -d github.com/skanehira/docui
  cd ${GOPATH}/src/github.com/skanehira/docui
fi
echo "Finished install docui !!"

text="Install Lazygit"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew install lazygit
elif [ $OS_TYPE == "Linux" ]; then
  add-apt-repository -y ppa:lazygit-team/release
  apt-get install -y lazygit
fi

text="Install ag & fzf"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew install ag
  brew install fzf
elif [ $OS_TYPE == "Linux" ]; then
  apt-get install -y silversearcher-ag
  if [ ! -d ${HOME}/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
    ${HOME}/.fzf/install
  fi
fi
echo "Finished install ag & fzf !!"

text="Install vim & tmux"
decoration
if [ $OS_TYPE == "Darwin" ]; then
  brew install vim
  brew install tmux
elif [ $OS_TYPE == "Linux" ]; then
  apt-get install -y vim
  apt-get install -y tmux
fi
sh ${SCRIPT_DIR}/vim/setup.sh
sh ${SCRIPT_DIR}/tmux/setup.sh
echo "Finished install vim & tmux !!"

if [ $OS_TYPE == "Darwin" ]; then
  text="Install gibo"
  decoration
  brew install gibo
fi

echo
echo "All installation is finished !!!!!!!!!!"
exit 0
