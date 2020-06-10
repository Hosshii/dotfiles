#!/bin/bash

DOTPATH="${HOME}/.dotfiles"
CONFPATH="${HOME}/.config/fish"

for i in $(ls ${DOTPATH}/fish/conf.d); do
    # echo "linking ${CONFPATH}/conf.d/${i} ---> ${DOTPATH}/fish/conf.d/${i}"
    ln -snf ${DOTPATH}/fish/conf.d/${i} "${CONFPATH}/conf.d/${i}"
done

for i in $(ls ${DOTPATH}/fish/functions); do
    # echo "linking ${CONFPATH}/functions/${i} ---> ${DOTPATH}/fish/functions/${i}"
    ln -snf ${DOTPATH}/fish/functions/${i} "${CONFPATH}/functions/${i}"
done
