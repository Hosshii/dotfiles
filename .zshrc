bindkey -e
alias x86="arch -x86_64 /bin/zsh -l"
alias arm="arch -arm64 /bin/zsh -l"
# Customize to your needs...
#エイリアスの設定
alias c="clear"
#alias cdd="cd ../"
#alias cddd="cd ../../"
#alias cdddd="cd ../../../"
# alias k='kubectl'
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
alias ls='exa --icons'
alias cat='bat'
# global alias is added in ~/.zsh/config/*

# pathの設定
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_141.jdk/Contents/Home"
export JAVA_HOME=""
export NODE_ENV="development"
#export PATH="$HOME/.nodebrew/current/bin:$PATH"
if [ "$(uname)" = 'Darwin' ];then
    # brew --prefixは遅いのでベタ書きする
    # export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
    # #export PATH="$PYENV_ROOT/bin:$PATH"
    # export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    # export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"
    # export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
    # export PATH="$(brew --prefix)/opt/binutils/bin:$PATH"
    # export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
    # export PATH="$(brew --prefix)/opt/openjdk/bin:$PATH"
    # export PATH="$(brew --prefix)/opt/qt/bin:$PATH"
    # export OPENSSL_INCLUDE_DIR=$(brew --prefix openssl)/include
    # export OPENSSL_LIB_DIR=$(brew --prefix openssl)/lib
    alias ssh='~/bin/ssh-change-profile.sh'
    export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
    #export PATH="$PYENV_ROOT/bin:$PATH"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
    export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
    export PATH="/opt/homebrew/opt/qt/bin:$PATH"
    export OPENSSL_INCLUDE_DIR="h/opt/homebrew/opt/openssl@1.1/include"
    export OPENSSL_LIB_DIR="/opt/homebrew/opt/openssl@1.1/lib"
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
    # brew --prefixは遅いのでベタ書きする
    # export FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
    # export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH"
    # export MANPATH="$(brew --prefix)/opt/findutils/libexec/gnuman:$MANPATH"
    export FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
    export MANPATH="/opt/homebrew/opt/findutils/libexec/gnuman:$MANPATH"
    function llvm (){
        export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"
        export LDFLAGS="-L$(brew --prefix)/opt/llvm/lib"
        export CPPFLAGS="-I$(brew --prefix)/opt/llvm/include"
        unset -f llvm
    }
elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
    
fi


# source ${HOME}/.ghcup/env
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
# export PATH="$PATH:${HOME}/localWorkspace/nand2tetris/tools"
export PATH="$PATH:${HOME}/.local/bin"
#export PATH="$PATH:./node_modules/.bin"
export TEXPATH="$HOME/tex"
export ATCODER="$HOME/localWorkspace/atcoder"
#export FPATH="$FPATH:$HOME/.zsh/completion:$HOME/.zsh/pure"
export FPATH="$FPATH:$HOME/.zsh/completion"
export CDD_DIR="$HOME/.cdd"
export TOOLBOX_TEMPLATE_DIR="${HOME}/.dotfiles/bin/template"
# lsはgnuのやつの表示が嫌だったのでmacのやつを使ってる

# #コマンド履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt EXTENDED_HISTORY

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export EDITOR=vim

# # homebrewで勝手にアップデートしない
export HOMEBREW_NO_AUTO_UPDATE=1

# 直前のコマンドの重複を削除
setopt hist_ignore_dups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

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
# autoload -Uz compinit
# compinit -u

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

zinit ice wait'0' lucid
zinit snippet PZT::modules/completion

autoload -Uz compinit
compinit

zinit cdreplay -q

# # zinit ice svn pick"init.zsh"
# # zinit snippet PZT::modules/git
# #export PATH="$HOME/.anyenv/bin:$PATH"
# if (which zprof > /dev/null) ;then
#   zprof | less
# fi
