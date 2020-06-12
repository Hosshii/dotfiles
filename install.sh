#!/bin/bash

GITHUB_URL="https://github.com/WistreHosshii/"
REPO_NAME="dotfiles"
DOTPATH=".dotfiles"
WORKDIR=$(pwd)/"$DOTPATH"

#コマンド確認
#gitコマンドが使えるか
if type git >/dev/null 2>&1; then
    $(git clone --recursive "$GITHUB_URL""$REPONAME"".git $DOTPATH")

#使えなかったらcurlかwgetを探す
elif type curl || type wget >/dev/null 2>&1; then
    tarball="url" #TODO
    if type curl >/dev/null 2>&1; then
        curl -LO "$tarball"

    elif type wget >/dev/null 2>&1; then
        wget -O - "$tarball"

    fi | tar zxv
    mv -f dotfiles-master "$DOTPATH"

else
    echo "curl or wget or git are required"
    exit 1
fi

#移動
cd "$WORKDIR"
if [ $? -ne 0 ]; then
    echo "$WORKDIR not found"
    exit 1
fi

make init
make deploy
make deploy_fish
make install_zinit
make brew
