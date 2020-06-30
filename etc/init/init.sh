#!/bin/bash

SCRIPT_DIR=$(dirname $(
    cd $(dirname $0)
    pwd
))

if [ ! -d "${HOME}/.dotfiles" ]; then
    ln -sfnv "$SCRIPT_DIR" "${HOME}/.dotfiles"
else
    echo "${HOME}/.dotfile already exist"
fi

xcode-select --install

# source ./bin/dotpath.sh
