#!/bin/bash

DOTFILES_TOOL_SRC="https://github.com/rhysd/dotfiles.git"
DOTFILES_TOOL="dotfiles_tool"
GITHUB_USER="Hosshii"
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_TOOK_BIN="dotfiles"

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

# clone rhysd/dotfiles
git clone "$DOTFILES_TOOK_SRC" "$DOTFILES_TOOL"
cd "$DOTFILES_TOOL" 
go install .

cd "$HOME"

"$DOTFILES_TOOK_BIN" clone "$GITHUB_USER"
cd "$DOTFILES_DIR"

if [ ! -d $HOME/bin ]; then
    mkdir "${HOME}/bin"
fi

if [ "$(uname)" == 'Darwin' ]; then
  xcode-select --install
  "$DOTFILES_TOOK_BIN" link
  make install_zinit
#   make deploy_fish
  make setup_vim
  make brew
  make setup_mac_default
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  "$DOTFILES_TOOK_BIN" link
  make install_zinit
#   make deploy_fish
  make setup_vim
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi
