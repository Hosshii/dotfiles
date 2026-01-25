{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--reverse"
      "--border"
      "-0"
      "--marker=⇡"
      "--bind=?:toggle-preview"
    ];
  };
}
