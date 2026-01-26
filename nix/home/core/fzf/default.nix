{
  programs.fzf = {
    enable = true;
    enableZshIntegration = false; # sheldon で遅延読み込みするため無効化
    defaultOptions = [
      "--reverse"
      "--border"
      "-0"
      "--marker=⇡"
      "--bind=?:toggle-preview"
    ];
  };
}
