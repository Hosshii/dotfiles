export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${HOME}/.local/bin"

export FPATH="$FPATH:$HOME/.zsh/completion"

# #コマンド履歴
export EDITOR=vim

# # homebrewで勝手にアップデートしない
export HOMEBREW_NO_AUTO_UPDATE=1

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export _Z_DATA="$XDG_DATA_HOME/z"
