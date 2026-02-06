{ homedir }:
{
  system = {
    stateVersion = 6;

    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        ApplePressAndHoldEnabled = false;
      };

      finder = {
        # 拡張子を常に表示する
        AppleShowAllExtensions = true;
        # 隠しファイルを常に表示する
        AppleShowAllFiles = true;
        # リストビューをデフォルトにする
        FXPreferredViewStyle = "Nlsv";
        FXDefaultSearchScope = "SCcf";
        ShowPathbar = true;
        ShowStatusBar = true;
        NewWindowTarget = "Other";
        NewWindowTargetPath = "file://${homedir}/";
        # 完全パスを表示する
        _FXShowPosixPathInTitle = true;
      };

      controlcenter = {
        # メニューバーにバッテリー残量を表示する
        BatteryShowPercentage = true;
      };

      dock = {
        autohide = true;
        # ホットコーナー(右上)にDisplay Sleepを設定する
        wvous-tr-corner = 10;
      };

      menuExtraClock = {
        # メニューバーの時計を24時間表示にする
        Show24Hour = true;
        # メニューバーに余裕がある場合は日付を表示する
        ShowDate = 0;
        # 日付を表示する
        ShowDayOfMonth = true;
        # 曜日を表示する
        ShowDayOfWeek = true;
        # 秒は表示しない
        ShowSeconds = false;
      };

      CustomUserPreferences = {
        "com.apple.desktopservices".DSDontWriteNetworkStores = true;
      };
    };
  };
}
