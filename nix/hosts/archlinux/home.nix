{ username, homedir, gitConfig }:
{
  imports = [
    (import ../../home/core { inherit gitConfig; })

    # GUI (Arch で使うもののみ)
    ../../home/gui/alacritty
    ../../home/gui/fonts

    # opt (terminal-notifier 以外)
    ../../home/opt/binutils
    ../../home/opt/cmake
    ../../home/opt/pstree
    ../../home/opt/time
  ];

  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";
  };
}
