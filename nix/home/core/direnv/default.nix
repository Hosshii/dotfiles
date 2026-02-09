{
  programs.direnv = {
    enable = true;
    enableZshIntegration = false; # sheldon で遅延読み込みするため
    nix-direnv.enable = true;
  };
}
