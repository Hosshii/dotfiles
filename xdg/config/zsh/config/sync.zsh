# https://github.com/zimfw/zimfw/issues/386
# zshrcだと読み込まれないことがある
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export HISTFILE=${ZDOTDIR}/history
export HISTSIZE=1000000
export SAVEHIST=1000000

bindkey -e

setopt EXTENDED_HISTORY
# 直前のコマンドの重複を削除
setopt hist_ignore_dups

# 同時に起動したzshの間でヒストリを共有
setopt share_history

#コマンドミス修正
setopt correct

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word

# コマンド実行後すぐに履歴に追加
setopt inc_append_history  

# 補完時にヒストリを自動的に展開         
setopt hist_expand

zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
