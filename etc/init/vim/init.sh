#!/bin/bash

if [ ! -d "${HOME}/.cache/dein" ]; then
    echo "set up vim dein"
    echo "install dein"
    echo ""
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh >installer.sh
    sh ./installer.sh ~/.cache/dein
    rm ./installer.sh
fi
