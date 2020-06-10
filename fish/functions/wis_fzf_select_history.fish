function wis_fzf_select_history
  #fc -l -n 1 | eval $tac | fzf --query (commandline)|read foo
  history | sed -e 's/^\:.*;//g' | fzf --height 40%  --query (commandline) |read foo
  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end