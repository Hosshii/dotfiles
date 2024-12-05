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

# return commi
alias -g C='`glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" | \
        sed "s/ .*//"`'

# rerutn branch
alias -g B='`git branch --all --color | grep -v HEAD | fzf -m --ansi | sed "s/.* //" | sed "s#remotes/[^/]*/##"`'

# return files
alias -g F='`unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '\''{print \$2}'\'' | xargs git diff --color --|diff-so-fancy" | awk '\''{print $2}'\'' | tr '\''\n'\'' '\'' '\''`'

alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
