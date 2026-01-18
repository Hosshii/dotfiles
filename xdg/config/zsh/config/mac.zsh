if [ "$(uname)" = 'Darwin' ];then
    alias x86="arch -x86_64 /bin/zsh -l"
    alias arm="arch -arm64 /bin/zsh -l"
    # iterm2 のテーマをデフォルトにセット
    echo -ne "\033]1337;SetProfile=Default\a"

    alias ssh='$XDG_CONFIG_HOME/zsh/functions/ssh-change-profile.sh'
    export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"

    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

    defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
fi
