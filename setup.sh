#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

case $( uname -s ) in
  Darwin|Linux) bash install.sh;;
  *)      echo "This is non supported Distribution." ; exit 1;;
esac

[ -e ${HOME}/.gitconfig -o -L ${HOME}/.gitconfig ] && rm -rf ${HOME}/.gitconfig
[ ! -L ${HOME}/.gitconfig ] && ln -s ${SCRIPT_DIR}/.gitconfig ${HOME}/.gitconfig

exit 0
