#ctr+rでfzfで履歴検索
setopt hist_ignore_all_dups
export FZF_DEFAULT_OPTS="--reverse --border -0 --marker "⇡"  --bind '?:toggle-preview'"

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
  # いきたい候補ふえたので分けた。
  # パスがざつなので他だとうまく動かないかも
  local mygitfull="/Users/wistre/localWorkspace"
  local mygit="localWorkspace"
  local bm="BookMark"
  local dir=$(echo "$(basename $(ghq root))\n${mygit}\n$bm" | fzf --prompt "WORKSPACE>")

  if [ $dir = $mygit ]; then
    local selected_dir="${mygitfull}/$(ls $mygitfull | fzf --ansi --prompt "Repository>" --query "$LBUFFER")"
  elif [ $dir = "$(basename $(ghq root))" ]; then
    # local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER" --preview "bat --color=always --style=header,grid --line-range :100 $(ghq root)/{}/README.*")"
    local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER" --preview "unbuffer onefetch $(ghq root)/{};bat --color=always --style=header,grid --line-range :100 "$(ghq root)/{}/README.md" "$(ghq root)/{}/readme.md" 2>/dev/null ")"
  elif [ $dir = $bm ]; then
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

## 今いるディレクトリの検索
#function fzf-path() {
#
#  # 最後が/で終わるかどうか(ディレクトリだったらctr＋jでその下の
#  # ディレクトリ を保管できるように
#  local tmp=${LBUFFER: -1}
#  if [ "$tmp" = "/" ]; then
#    # チルダは手動で展開する
#    # tmpにディレクトリ 名と思わし着物を格納
#    # 例えば cd /usr/bin/ でこのショートカットを使った場合
#    # tmpには /usr/bin/が入る
#    tmp=$(echo $LBUFFER | awk '{print $NF}' | sed -e "s#~#$HOME#")
#    # tmpがディレクトリかどうか確認
#    if [ -d $tmp ]; then
#      # ディレクトリならそこを検索対象にする
#      local search=$tmp
#    fi
#  fi
#
#  # 表示するファイルパス
#  # searchがあるなら、そのディレクトリ以下をfdコマンドで探す。
#  # そうじゃない時は、カレンとディレクトリ
#  # previewには、選択しているものがディレクトリならexaでツリー状に表示(カラーにするとうまくいかなかったのでしてない)
#  # ファイルならbatコマンドで表示している
#  #local filepath="$(fd . $search -H -E ".git" -c always | fzf --ansi --prompt 'PATH>' --preview 'if [ -d {} ];then exa   -T --git-ignore  {}|head -200;elif [ -f {} ];then bat --color=always --style=header,grid --line-range :100 {} | head -100;fi ')"
#  local filepath="$(fd . $search -H -E ".git" -c always | fzf --ansi --prompt 'PATH>' --preview 'if [ -d {} ];then tree  {}|head -200;elif [ -f {} ];then bat --color=always --style=header,grid --line-range :100 {} | head -100;fi ')"
#  [ -z "$filepath" ] && return
#
#  # filepathは$searchのところも含まれているので、そこを除く。ディレクトリなら最後に/をつける。
#  if [ ! -z $search ]; then
#    if [ -d $filepath ]; then
#      filepath="$(echo $filepath | sed -e "s#$search##")/"
#    elif [ -f $filepath ]; then
#      filepath=$(echo $filepath | sed -e "s#$search##")
#    fi
#  fi
#
#  # プロンプトで何か入力したあとにこのショートカットを使ったなら、そこに選んだファイルパスを付け加える。
#  if [ -n "$LBUFFER" ]; then
#    BUFFER="$LBUFFER$filepath"
#  else
#    # 何もない状態でディレクトリなら移動する。
#    if [ -d "$filepath" ]; then
#      BUFFER="cd $filepath"
#      zle accept-line
#    # ファイルなら$EDITORで開く。
#    elif [ -f "$filepath" ]; then
#      BUFFER="$EDITOR $filepath"
#      zle accept-line
#    fi
#  fi
#  zle clear-screen
#  CURSOR=$#BUFFER
#}
#
#zle -N fzf-path
#bindkey '^j' fzf-path # Ctrl+f で起動

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
