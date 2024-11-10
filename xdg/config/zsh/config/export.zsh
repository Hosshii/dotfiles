export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${HOME}/.local/bin"

export FPATH="$FPATH:$HOME/.zsh/completion"

# #コマンド履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

export EDITOR=vim

# # homebrewで勝手にアップデートしない
export HOMEBREW_NO_AUTO_UPDATE=1