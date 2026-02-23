#ctr+rでfzfで履歴検索
function fzf_select_history() {
  local tac
  if which tac >/dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N fzf_select_history
bindkey '^r' fzf_select_history

# ctr+gでworkspaceにいく
function fzf-src() {
  local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER" --preview "unbuffer onefetch $(ghq root)/{} ;bat --color=always --style=header,grid --line-range :100 "$(ghq root)/{}/README.md" "$(ghq root)/{}/$(find . -maxdepth 1 -type f -iname "readme*" | sed 's!^.*/!!')" 2>/dev/null ")"

  BUFFER="cd ${selected_dir}"            
  zle accept-line

  zle clear-screen
}
zle -N fzf-src
bindkey '^g' fzf-src

# ctrl+nで今までに行ったことにあるディレクトリ をサーチ。
fzf-z-search() {
  local res=$(z | sort -rn | cut -c 12- | fzf)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}

zle -N fzf-z-search
bindkey '^n' fzf-z-search

# 全履歴を一覧表示
function history-all { history -E 1 }
