#!/bin/bash

SCRIPT_DIR=$(dirname $(
    cd $(dirname $0)
    pwd
))

if ! type brew >/dev/null 2>&1; then
    echo "installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if ! type brew >/dev/null 2>&1; then
    echo "brew is not found"
    echo "exit"
    exit 1
fi

echo "run brew doctor"
brew doctor

echo "brew update"
brew update

echo "brew bundle --global"
brew bundle --global
