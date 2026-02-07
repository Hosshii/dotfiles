{ pkgs, system, username, homedir, self, brew-nix ,... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.defaultbrowser
  ];

  # installed via determinate
  nix.enable = false;

  brew-nix.enable = true;
  
  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  nixpkgs.config.allowUnfree = true;

  # これを設定しないと homeDirectory is nullみたいなエラーになる
  # https://github.com/nix-community/home-manager/issues/6743
  # https://github.com/nix-community/home-manager/issues/6557
  system.primaryUser = username;

  users.users.${username}.home = homedir;

  system.activationScripts.setDefaultBrowser.text = ''
    sudo -u ${username} ${pkgs.defaultbrowser}/bin/defaultbrowser firefox
  '';

  imports = [
    ./_1password/default.nix
    ./zsh/default.nix
    (import ./defaults/default.nix { inherit homedir; })
  ];
}
