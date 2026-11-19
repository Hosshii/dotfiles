{ hostConfig, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostConfig.hostname;
  networking.networkmanager.enable = true;

  users.users."${hostConfig.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "26.05";
}
