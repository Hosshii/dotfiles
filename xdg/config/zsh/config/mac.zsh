if [ "$(uname)" = 'Darwin' ];then
    alias x86="arch -x86_64 /bin/zsh -l"
    alias arm="arch -arm64 /bin/zsh -l"
    # iterm2 のテーマをデフォルトにセット
    echo -ne "\033]1337;SetProfile=Default\a"

    alias ssh='~/bin/ssh-change-profile.sh'
     . /opt/homebrew/opt/asdf/libexec/asdf.sh
    export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi