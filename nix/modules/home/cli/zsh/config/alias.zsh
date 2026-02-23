#エイリアスの設定
alias c="clear"
alias py="python"
alias g="git"
alias la='ls -a'
alias ll='ls -lgh --git'
alias lla='ls -lgha --git'
alias lal='ls -lgha --git'
alias ls='eza --icons=auto --git'
alias cat='bat'
alias code-arch='code --remote ssh-remote+arch'

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | delta'"

# return commit
alias -g C='`glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" | \
        sed "s/ .*//"`'

# return branch
alias -g B='`git branch --all --color | grep -v HEAD | fzf -m --ansi | sed "s/.* //" | sed "s#remotes/[^/]*/##"`'

# return files
alias -g F='`unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '\''{print \$2}'\'' | xargs git diff --color | delta" | awk '\''{print $2}'\'' | tr '\''\n'\'' '\'' '\''`'

alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
