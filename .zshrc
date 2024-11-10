bindkey -e
# Customize to your needs...
#エイリアスの設定
alias c="clear"
alias py="python"
# alias cat="cat -v"
alias g="git"
alias lzd="lazydocker"
alias lg="lazygit"
alias ks="ls"
alias la='ls -a'
alias ll='ls -lgh --git'
alias lla='ls -lgha --git'
alias lal='ls -lgha --git'
alias ls='eza --icons=auto --git'
alias cat='bat'
alias code-arch='code --remote ssh-remote+arch'
# global alias is added in ~/.zsh/config/*

# pathの設定
#export PATH="$HOME/.nodebrew/current/bin:$PATH"
if [ "$(uname)" = 'Darwin' ];then
    alias x86="arch -x86_64 /bin/zsh -l"
    alias arm="arch -arm64 /bin/zsh -l"
    # iterm2 のテーマをデフォルトにセット
    echo -ne "\033]1337;SetProfile=Default\a"

    alias ssh='~/bin/ssh-change-profile.sh'
     . /opt/homebrew/opt/asdf/libexec/asdf.sh
    export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
    . /opt/asdf-vm/asdf.sh
fi

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${HOME}/.local/bin"

export FPATH="$FPATH:$HOME/.zsh/completion"

# #コマンド履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt EXTENDED_HISTORY

export EDITOR=vim

# # homebrewで勝手にアップデートしない
export HOMEBREW_NO_AUTO_UPDATE=1

# 直前のコマンドの重複を削除
setopt hist_ignore_dups


# 同時に起動したzshの間でヒストリを共有
setopt share_history

#コマンドミス修正
setopt correct

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word

# 全履歴を一覧表示
function history-all { history -E 1 }

#ssh keyの設定
#.ssh/configで設定したので消してみる
#ssh-add -K
#
# fzfとかの関数の設定
for i in `\ls  ${HOME}/.zsh/config`;do
    source ${HOME}/.zsh/config/${i}
done

# 補完関数の設定
# source $HOME/.zsh/load/init.sh
for file in `find $HOME/.zsh/functions -mindepth 1`;do
    autoload -Uz $file
done

# zの読み込み
source "$(ghq root)/github.com/rupa/z/z.sh"


zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
#zstyle ':completion:*:*:kubectl:*' list-grouped false
#kubectl completion zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node
### End of Zinit's installer chunk

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma-continuum/fast-syntax-highlighting \
    light-mode pick"async.zsh" src"pure.zsh" \
                sindresorhus/pure \
    light-mode supercrabtree/k \
    # light-mode  zsh-users/zsh-completions 
    # zdharma-continuum/history-search-multi-word \


zinit snippet PZT::modules/environment 
zinit snippet PZT::modules/directory 
zinit snippet PZT::modules/terminal 

zinit ice wait'0' lucid blockf
zinit snippet PZT::modules/completion

autoload -Uz compinit
compinit

zinit cdreplay -q


autoload -U +X bashcompinit && bashcompinit

eval "$(starship init zsh)"
