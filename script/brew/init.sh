#!/bin/bash

echo "Init Home Brew."

SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

if ! type brew >/dev/null 2>&1; then
    echo "installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

if ! type brew >/dev/null 2>&1; then
    echo "brew is not found"
    echo "exit"
    exit 1
fi

echo "run brew doctor"
brew doctor

echo "brew update"
brew update

echo "brew bundle --file $SCRIPT_DIR/Brewfile"
echo "install core."
brew bundle --file "$SCRIPT_DIR/Brewfile"

echo ""
echo "brew process finished!"
