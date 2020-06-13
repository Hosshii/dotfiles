#!/bin/bash

if [ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]; then
    echo "set up vim vundle"
    echo "install vundle"
    echo ""
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo "install plugin"
echo ""
vim +PluginInstall +qall
