function wis_fzf_z_search
  set --local res (z -l | sort -rn | cut -c 12- | fzf)
  if [ -n "$res" ]
    commandline $res
    commandline -f execute
  else
    return 1
  end
  commandline -f repaint
end

