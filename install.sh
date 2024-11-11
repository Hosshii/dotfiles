#!/bin/bash

set -eux

GITHUB_USER="Hosshii"
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_TOOL_BIN="/usr/local/bin/dotfiles"
DOTFILES_TOOL_VERSION="v0.2.3"

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
checkcommand "curl"
checkcommand "unzip"

if [ "$(uname)" = 'Darwin' ];then
  DOTFILE_DOWNLOAD_NAME="dotfiles_darwin_arm64.zip"
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
  DOTFILE_DOWNLOAD_NAME="dotfiles_linux_amd64.zip"
else 
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

echo "Instal ${DOTFILE_DOWNLOAD_NAME}"
curl -OL https://github.com/rhysd/dotfiles/releases/download/${DOTFILES_TOOL_VERSION}/${DOTFILE_DOWNLOAD_NAME}
unzip ${DOTFILE_DOWNLOAD_NAME}
rm ${DOTFILE_DOWNLOAD_NAME}
sudo mv dotfiles $DOTFILES_TOOL_BIN

cd "$HOME"

"$DOTFILES_TOOL_BIN" clone "$GITHUB_USER"
cd "$DOTFILES_DIR"

sudo echo 'export ZDOTDIR="$XDG_CONFIG_HOME"/zsh' >> /etc/zshenv

if [ "$(uname)" == 'Darwin' ]; then
  "$DOTFILES_TOOL_BIN" link
  ./script/manual/init.sh
  ./script/brew/init.sh
  ./script/vim/init.sh
  ./script/default_write/init.sh
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  "$DOTFILES_TOOL_BIN" link
  ./script/manual/init.sh
  ./script/pacman/init.sh
  ./script/vim/init.sh
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi
