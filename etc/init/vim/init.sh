#!/bin/bash

if [ ! -d "${HOME}/.cache/dein" ]; then
    echo "set up vim dein"
    echo "install dein"
    echo ""
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)"
fi
