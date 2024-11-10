#ctr+rでfzfで履歴検索
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
  local workspace="$(basename $(ghq root))"
  local mygitfull="${HOME}/localWorkspace"
  local mygit="localWorkspace"
  local bm="BookMark"
  local dir=$(echo "$(basename $(ghq root))\n${mygit}\n$bm" | fzf --prompt "WORKSPACE>")

  if [ $dir = $mygit ]; then
    local selected_dir="${mygitfull}/$(\ls $mygitfull | fzf --ansi --prompt "Repository>" --query "$LBUFFER")"
  elif [ $dir = "$workspace" ]; then
    # local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER" --preview "bat --color=always --style=header,grid --line-range :100 $(ghq root)/{}/README.*")"
    local selected_dir="$(ghq root)/$(ghq list | fzf --prompt "Repository>" --query "$LBUFFER" --preview "unbuffer onefetch $(ghq root)/{} ;bat --color=always --style=header,grid --line-range :100 "$(ghq root)/{}/README.md" "$(ghq root)/{}/$(find . -maxdepth 1 -type f -iname "readme*" | sed 's!^.*/!!')" 2>/dev/null ")"
  elif [ $dir = $bm ]; then
    local selected_dir=$(cdd-manager list | fzf --ansi --prompt "BookMark" --query "$LBUFFER" | awk '{print $3}')
  fi

  if [ -n "$selected_dir" ]; then
    case "$selected_dir" in
        "${mygitfull}/" | "$(ghq root)/")  ;;
        * )  BUFFER="cd ${selected_dir}"
             zle accept-line ;;
    esac
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



# 全履歴を一覧表示
function history-all { history -E 1 }

# fbr - checkout git branch (including remote branches)
gchb() {
  local branches branch
  branch=$(echo B)
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fco - checkout git branch/tag
gcht() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}


# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
gcht_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

gshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"

_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

# fshow_preview - git commit browser with previews
gshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

# gchc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$( echo C )
  git checkout $(echo "$commit")
}

gstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

gadd() {
    local selected
    selected=$(echo F)
    if [[ -n "$selected" ]]; then
        echo $selected
        git add $(echo $selected)
        echo "Completed: git add $selected"
    fi
}

