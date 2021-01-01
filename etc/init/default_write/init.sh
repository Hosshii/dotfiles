#!/bin/bash

set -eux

echo "default write"
echo ""
defaults write NSGlobalDomain KeyRepeat -int 2                      # キーリピートの速度
defaults write NSGlobalDomain InitialKeyRepeat -int 15              # キーリピート開始までのタイミング
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # 検索時にデフォルトでカレントディレクトリを検索する
defaults write com.apple.finder ShowPathbar -bool true              # パスバーを表示する
defaults write com.apple.finder ShowStatusBar -bool true            # ステータスバーを表示する
defaults write com.apple.finder ShowTabView -bool true              # タブバーを表示する
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false   # ファイルのダウンロード後に自動でファイルを開くのを無効化する
defaults write com.apple.dock autohide -bool true                   # Automatically hide or show the Dock （Dock を自動的に隠す）
defaults write -g ApplePressAndHoldEnabled -bool false              # キー長押しした時にアクセント文字を表示しない

# finder
# 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder ShowStatusBar -bool true # Show Status bar in Finder （ステータスバーを表示）
defaults write com.apple.finder ShowPathbar -bool true   # Show Path bar in Finder （パスバーを表示）
defaults write com.apple.finder ShowTabView -bool true   # Show Tab bar in Finder （タブバーを表示）
chflags nohidden ~/Library                               # Show the ~/Library directory （ライブラリディレクトリを表示、デフォルトは非表示）

#safari
# Enable the `Develop` menu and the `Web Inspector` （開発メニューを表示）
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# Show the full URL in the address bar (note: this will still hide the scheme)
# アドレスバーに完全なURLを表示
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Show Safari's Status Bar （ステータスバーを表示）
defaults write com.apple.Safari ShowStatusBar -bool true

# Avoid creating `.DS_Store` files on network volumes （ネットワークディスクで、`.DS_Store` ファイルを作らない）
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# others
# Hide the battery percentage from the menu bar （バッテリーのパーセントを非表示にする）
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
# Date options: Show the day of the week: on （日付表示設定、曜日を表示）
defaults write com.apple.menuextra.clock 'DateFormat' -string 'M\\U6708d\\U65e5(EEE)  H:mm'

echo ""
echo "finished"
