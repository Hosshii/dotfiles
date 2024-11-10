bindkey -e

setopt EXTENDED_HISTORY
# 直前のコマンドの重複を削除
setopt hist_ignore_dups

# 同時に起動したzshの間でヒストリを共有
setopt share_history

#コマンドミス修正
setopt correct

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
