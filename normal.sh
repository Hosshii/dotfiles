#ctr+rでfzfで履歴検索
setopt hist_ignore_all_dups
export FZF_DEFAULT_OPTS="--reverse --border -0 -1 --bind '?:toggle-preview'"

function fzf_select_history() {
  local tac
  if which tac > /dev/null; then
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
function fzf-src () {
  local mygitfull="/Users/wistre/localWorkspace"
  local mygit="localWorkspace"
  local dir=$(echo "$(basename $(ghq root))\n${mygit}"|fzf --prompt "WORKSPACE>")

  if [ $dir = $mygit ];then
      local selected_dir="${mygitfull}/$(ls $mygitfull|fzf --prompt "Repository>" --query "$LBUFFER")"
  elif [ $dir = "$(basename $(ghq root))" ];then
          local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER")"
      fi

  if [ -n "$selected_dir" ]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-src
bindkey '^g' fzf-src

# 今いるディレクトリの検索
function fzf-path() {
local filepath="$(exa -d --group-directories-first --git-ignore --color=always  $( find . -mindepth 1 -not -iwholename *.git/* 2>/dev/null | head -100) | fzf --ansi --prompt 'PATH>' --preview 'if [ -d {} ];then exa --color=always  -T --git-ignore  {}|head -200;elif [ -f {} ];then bat --color=always --style=header,grid --line-range :100 {};fi ')"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
      BUFFER="$LBUFFER$filepath"
  else
      if [ -d "$filepath" ]; then
          BUFFER="cd $filepath"
          zle accept-line
      elif [ -f "$filepath" ]; then
          BUFFER="$EDITOR $filepath"
          zle accept-line
    fi
  fi
  zle clear-screen
  CURSOR=$#BUFFER
}

zle -N fzf-path
bindkey '^j' fzf-path # Ctrl+f で起動


