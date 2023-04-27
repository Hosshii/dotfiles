#!/bin/bash

set -eux

DOTFILES_TOOL_SRC="https://github.com/rhysd/dotfiles.git"
GITHUB_USER="Hosshii"
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_TOOL_BIN="${GOPATHH-"${HOME}/go"}/bin/dotfiles"

function checkcommand() {
    if type $1 > /dev/null 2>&1; then
        echo "exist $1"
    else
        echo "not exist $1"
        exit 1
    fi
}

#コマンド確認
#gitコマンドが使えるか
checkcommand "git"
checkcommand "cargo"
checkcommand "make"
checkcommand "go"

# install rhysd/dotfiles
go install github.com/rhysd/dotfiles@latest

cd "$HOME"

"$DOTFILES_TOOL_BIN" clone "$GITHUB_USER"
cd "$DOTFILES_DIR"

if [ ! -d $HOME/bin ]; then
    mkdir "${HOME}/bin"
fi

if [ "$(uname)" == 'Darwin' ]; then
  xcode-select --install
  "$DOTFILES_TOOL_BIN" link
  make install_zinit
#   make deploy_fish
  make setup_vim
  make brew
  make setup_mac_default
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  "$DOTFILES_TOOL_BIN" link
  make install_zinit
#   make deploy_fish
  make setup_vim
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi
