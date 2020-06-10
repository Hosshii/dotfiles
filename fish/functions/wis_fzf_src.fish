function wis_fzf_src
  # いきたい候補ふえたので分けた。
  # パスがざつなので他だとうまく動かないかも
  set --local mygitfull "/Users/wistre/localWorkspace"
  set --local mygit "localWorkspace"
  set --local bm "BookMark"
  set --local dir (echo (basename (ghq root))\n{$mygit}\n$bm | fzf --prompt "WORKSPACE>")
  set --local ghqroot (ghq root)
  set --local selected_dir ""

  if [ $dir = $mygit ]
    set selected_dir {$mygitfull}/(ls $mygitfull|fzf --ansi --prompt "Repository>" --query (commandline))
  else if [ $dir = (basename (ghq root)) ]
    set selected_dir (ghq root)/(ghq list | fzf --prompt "Repository>" --query (commandline) --preview "bat --color=always --style=header,grid --line-range :100 $ghqroot/{}/README.*")
  else if [ $dir = $bm ]
    set selected_dir (cdd-manager list | fzf --ansi --prompt "BookMark" --query (commandline) | awk '{print $3}')
  end

  if [ -n "$selected_dir" ]
      commandline "cd $selected_dir"
      commandline -f execute
  end
  commandline -f repaint
end