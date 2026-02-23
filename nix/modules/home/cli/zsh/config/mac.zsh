if [ "$(uname)" = 'Darwin' ];then
    alias x86="arch -x86_64 /bin/zsh -l"
    alias arm="arch -arm64 /bin/zsh -l"
fi
