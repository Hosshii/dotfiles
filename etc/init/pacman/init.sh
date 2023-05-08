#!/bin/bash

set -eux

SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)

if ! type pacman >/dev/null 2>&1; then
    echo "pacman does not exist"
    exit 1
fi

if ! type paru >/dev/null 2>&1; then
    echo "paru does not exist"
    exit 1
fi

sudo pacman -Syu
sudo pacman -S --needed - < ${SCRIPT_DIR}/pkglist.txt

paru -Syu
paru -S --needed - < ${SCRIPT_DIR}/foreignpkglist.txt

echo "finished successfully!!"