#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)
GOPATH=${HOME}/go

if [ ! -d ${HOME}/.cache/dein ]; then
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh
  sh /tmp/installer.sh ${HOME}/.cache/dein
  rm -f /tmp/installer.sh
fi

[ -d ${HOME}/.config/dein -o -L ${HOME}/.config/dein ] && rm -rf ${HOME}/.config/dein
[ ! -L ${HOME}/.config/dein ] && ln -s ${SCRIPT_DIR}/dein ${HOME}/.config/dein

[ -e ${HOME}/.vimrc -o -L ${HOME}/.vimrc ] && rm -rf ${HOME}/.vimrc
[ ! -L ${HOME}/.vimrc ] && ln -s ${SCRIPT_DIR}/.vimrc ${HOME}/.vimrc

[ -e ${HOME}/.ideavimrc -o -L ${HOME}/.ideavimrc ] && rm -rf ${HOME}/.ideavimrc
[ ! -L ${HOME}/.ideavimrc ] && ln -s ${SCRIPT_DIR}/.ideavimrc ${HOME}/.ideavimrc

exit 0

