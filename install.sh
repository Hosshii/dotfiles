#!/bin/bash

GITHUB_URL="https://github.com/WistreHosshii/"
DOTPATH="dotfiles"
WORKDIR=$(pwd)/"$DOTPATH"

#コマンド確認
#gitコマンドが使えるか
if type git >/dev/null 2>&1; then
    git clone --recursive $("$GITHUB_URL""$DOTPATH")

#使えなかったらcurlかwgetを探す
elif type curl wget >/dev/null 2>&1; then
    tarball="url"
    if type curl >/dev/null 2>&1; then
        curl -L "$tarball"
        
    elif type wget >/dev/null 2>&1; then
        wget -O - "$tarball"

    fi |tar zxv
    mv -f dotfiles-master "$DOTPATH"

else
    echo "curl or wget or git are required"
    exit 1
fi

#移動
cd "$WORKDIR"
if [ $? -ne 0 ]; then
    echo "$DOTPATH not found"
    exit 1
fi

for f in .??
do
    [ "$f" = ".git" ] && continue
    ln -snfv "$DOTPATH/$f" "$HOME"_"$f"
done
