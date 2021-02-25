
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Customize to your needs...
#エイリアスの設定
alias ls='ls -F --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias c="clear"
#alias cdd="cd ../"
#alias cddd="cd ../../"
#alias cdddd="cd ../../../"
alias cdu='cd-gitroot'
alias k='kubectl'
alias py="python"
alias cddm="cdd-manager"
# alias cat="cat -v"
alias g="git"
alias lzd="lazydocker"
alias lg="lazygit"
# global alias is added in ~/.zsh/config/*

# pathの設定
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_141.jdk/Contents/Home"
export JAVA_HOME=""
export NODE_ENV="development"
#export PATH="$HOME/.nodebrew/current/bin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
#export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/binutils/bin:$PATH"
export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/openjdk/bin:$PATH"
export PATH="$(brew --prefix)/opt/qt/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:${HOME}/localWorkspace/nand2tetris/tools"
#export PATH="$PATH:./node_modules/.bin"
export TEXPATH="$HOME/tex"
export ATCODER="$HOME/localWorkspace/atcoder"
#export FPATH="$FPATH:$HOME/.zsh/completion:$HOME/.zsh/pure"
export FPATH="$FPATH:$HOME/.zsh/completion"
export FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH="$(brew --prefix)/opt/findutils/libexec/gnuman:$MANPATH"
export CDD_DIR="$HOME/.cdd"
# lsはgnuのやつの表示が嫌だったのでmacのやつを使ってる

#コマンド履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt EXTENDED_HISTORY

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export EDITOR=vim

# homebrewで勝手にアップデートしない
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
source $HOME/.zsh/load/init.sh
for file in `find $HOME/.zsh/functions -mindepth 1`;do
    autoload -Uz $file
done
autoload -Uz compinit
compinit -u

# zの読み込み
source "$(ghq root)/github.com/rupa/z/z.sh"


zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
#zstyle ':completion:*:*:kubectl:*' list-grouped false
#kubectl completion zsh
# 関数の読み込み


# func of bandit
#banditssh()
#{
#    host="bandit.labs.overthewire.org"
#    echo "now connecting to $host"
#    echo -e "your user name is bandit\033[0;32m$@\033[0;39m"
#    ssh bandit"$@"@$host -p 2220
#}
#
#lsos()
#{
#    pwd | awk -F "/" '{print "../../../30nichideosjisaku/"$(NF-1)"/"$NF}'|xargs -I {} ls -GF {}
#}

function llvm (){
    export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"
    export LDFLAGS="-L$(brew --prefix)/opt/llvm/lib"
    export CPPFLAGS="-I$(brew --prefix)/opt/llvm/include"
    unset -f llvm
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node
### End of Zinit's installer chunk

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
    light-mode pick"async.zsh" src"pure.zsh" \
                sindresorhus/pure \
    # light-mode  zsh-users/zsh-completions 
    # zdharma/history-search-multi-word \


zinit snippet PZT::modules/environment 
zinit snippet PZT::modules/directory 
zinit snippet PZT::modules/terminal 
zinit snippet PZT::modules/completion

# zinit ice svn pick"init.zsh"
# zinit snippet PZT::modules/git
#export PATH="$HOME/.anyenv/bin:$PATH"
