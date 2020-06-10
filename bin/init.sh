#!/bin/bash

SCRIPT_DIR=$(dirname $(
    cd $(dirname $0)
    pwd
))

if [ ! -d "${HOME}/.dotfiles" ]; then
    ln -s "$SCRIPT_DIR" "${HOME}/.dotfiles"
fi

source ./bin/dotpath.sh
