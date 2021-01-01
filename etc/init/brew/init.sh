#!/bin/bash

SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

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

if [ "$1" = "-s" ]; then
    echo "brew bundle --file $SCRIPT_DIR/Core"
    echo "install core."
    brew bundle --file "$SCRIPT_DIR/Core"
else
    echo "install core and sub."
    echo "brew bundle --file $SCRIPT_DIR/Core"
    brew bundle --file "$SCRIPT_DIR/Core"
    brew bundle --file "$SCRIPT_DIR/Sub"
fi

echo "linking  gcc and g++"
echo ""
ln -sfnv /usr/local/bin/gcc-9 /usr/local/bin/gcc
ln -sfnv /usr/local/bin/g++-9 /usr/local/bin/g++
echo "done"

echo ""
echo "brew process finished!"
