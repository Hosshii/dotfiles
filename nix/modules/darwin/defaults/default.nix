{ homedir }:
{
  power = {
    sleep = {
      display = 10;
      computer = 10;
    };
  };

  system = {
    startup.chime = false;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        ApplePressAndHoldEnabled = false;
        _HIHideMenuBar = true;
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
        persistent-apps = [
          "/System/Applications/Mail.app"
          "/System/Applications/System Settings.app"
          "${homedir}/Applications/Home Manager Apps/Firefox.app"
          "${homedir}/Applications/Home Manager Apps/Google Chrome.app"
          "${homedir}/Applications/Home Manager Apps/Visual Studio Code.app"
          "/Applications/1Password.app"
        ];
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

      WindowManager = {
        # ウィジェットを表示しない
        StandardHideWidgets = true;
      };

      CustomUserPreferences = {
        "com.apple.desktopservices".DSDontWriteNetworkStores = true;

        # macOS UI 言語を日本語優先にする
        NSGlobalDomain = {
          AppleLanguages = [
            "ja-JP"
            "en-JP"
          ];
          AppleLocale = "ja_JP";
        };

        # 日本語 IME のライブ変換を無効化する
        "com.apple.inputmethod.Kotoeri".JIMPrefLiveConversionKey = false;

        # 入力ソースを ABC と Apple 日本語入力に固定する
        "com.apple.HIToolbox".AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 252;
            "KeyboardLayout Name" = "ABC";
          }
          {
            "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
            InputSourceKind = "Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.inputmethod.Kotoeri.RomajiTyping";
            "Input Mode" = "com.apple.inputmethod.Japanese";
            InputSourceKind = "Input Mode";
          }
        ];

        # Ctrl+Space で入力ソース切替を有効化する
        "com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
          "60" = {
            enabled = true;
            value = {
              parameters = [
                32
                49
                262144
              ];
              type = "standard";
            };
          };

          "61".enabled = false;
        };
      };
    };
  };
}
