{
  programs.zsh = {
    enable = true;
    # 遅くなるので無効化する。home-manager の sheldon で設定している
    enableCompletion = false;
    enableBashCompletion = false;
    promptInit = "";
  };
}
