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
        NewWindowTarget = "PfDe";
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

      CustomUserPreferences = {
        "com.apple.desktopservices".DSDontWriteNetworkStores = true;
      };
    };
  };
}
