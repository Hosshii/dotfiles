{
  custom.sheldon.plugins.direnv = {
    order = 600;
    text = "inline = '''
zsh-defer -c 'eval \"$(direnv hook zsh)\"'
'''";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = false; # sheldon で遅延読み込みするため
    nix-direnv.enable = true;
  };
}
