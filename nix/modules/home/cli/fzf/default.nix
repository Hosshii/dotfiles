{
  custom.sheldon.plugins.fzf = {
    order = 700;
    text = "inline = 'zsh-defer -c \"source <(fzf --zsh)\"'";
  };

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
