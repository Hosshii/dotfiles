#ctr+rでfzfで履歴検索
setopt hist_ignore_all_dups
export FZF_DEFAULT_OPTS="--reverse --border -0 --marker "⇡"  --bind '?:toggle-preview'"

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
  local bm="BookMark"
  local dir=$(echo "$(basename $(ghq root))\n${mygit}\n$bm"|fzf --prompt "WORKSPACE>")

  if [ $dir = $mygit ];then
      local selected_dir="${mygitfull}/$(ls $mygitfull|fzf --ansi --prompt "Repository>" --query "$LBUFFER")"
  elif [ $dir = "$(basename $(ghq root))" ];then
          local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER")"
  elif [ $dir = $bm ];then
      local selected_dir=$(cdd-manager list | fzf --ansi --prompt "BookMark" --query "$LBUFFER" | awk '{print $3}')
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
local tmp=${LBUFFER: -1}
if [ "$tmp" = "/" ];then
    tmp=$(echo $LBUFFER | awk '{print $NF}')
    if [ -d $tmp ];then
        local search=$tmp
    fi
fi

local filepath="$(fd . $search -H -E ".git" -c always | fzf --ansi --prompt 'PATH>' --preview 'if [ -d {} ];then exa   -T --git-ignore  {}|head -200;elif [ -f {} ];then bat --color=always --style=header,grid --line-range :100 {};fi ')"
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
bindkey '^k' fzf-z-search
