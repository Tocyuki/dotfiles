#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

fish -C "\
fisher install jethrokuan/z;\
fisher install oh-my-fish/theme-eclm;\
fisher install jethrokuan/fzf;\
fisher install decors/fish-ghq;\
fisher install edc/bass\
"&

[ -e ${HOME}/.config/fish/config.fish -o -L ${HOME}/.config/fish/config.fish ] && rm -rf ${HOME}/.config/fish/config.fish
[ ! -L ${HOME}/.config/fish/config.fish ] && ln -s ${SCRIPT_DIR}/config.fish ${HOME}/.config/fish/config.fish

chsh -s $(which fish)
exit 0

