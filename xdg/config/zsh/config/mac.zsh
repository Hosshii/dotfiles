if [ "$(uname)" = 'Darwin' ];then
    alias x86="arch -x86_64 /bin/zsh -l"
    alias arm="arch -arm64 /bin/zsh -l"
    # iterm2 のテーマをデフォルトにセット
    echo -ne "\033]1337;SetProfile=Default\a"

    alias ssh='ssh_change_profile'
     . /opt/homebrew/opt/asdf/libexec/asdf.sh
    export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi