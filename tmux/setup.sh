#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ ! -d ${HOME}/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
fi

[ -d ${HOME}/.tmux.conf -o -L ${HOME}/.tmux.conf ] && rm -rf ${HOME}/.tmux.conf
[ ! -L ${HOME}/.tmux.conf ] && ln -s ${SCRIPT_DIR}/.tmux.conf ${HOME}/.tmux.conf

exit 0

