{ hostConfig, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "module_blacklist=nouveau" ];

  networking.hostName = hostConfig.hostname;
  networking.networkmanager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  users.users."${hostConfig.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "26.05";
}
