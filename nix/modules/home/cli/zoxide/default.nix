{
  custom.sheldon.plugins.zoxide = {
    order = 800;
    text = "inline = '''
zsh-defer -c 'eval \"$(zoxide init zsh)\"'
'''";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = false; # sheldon で遅延読み込みするため無効化
  };
}
