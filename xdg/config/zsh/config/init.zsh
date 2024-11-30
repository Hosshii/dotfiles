export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# xdg の設定　
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export _Z_DATA="$XDG_DATA_HOME/z"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
