{ hostConfig, ... }:
{
  imports = [
    ../../home/core

    # GUI (Arch で使うもののみ)
    ../../home/gui/alacritty
    ../../home/gui/fonts

    # opt (terminal-notifier 以外)
    ../../home/opt/binutils
    ../../home/opt/cmake
    ../../home/opt/pstree
    ../../home/opt/time
  ];

  custom.git = {
    name = "Hosshii";
    email = "sao_heath6147.wistre@icloud.com";
    ghq.enable = true;
    wt.enable = true;
    delta.enable = true;
  };

  home = {
    username = hostConfig.username;
    homeDirectory = hostConfig.homedir;
    stateVersion = "25.11";
  };
}
