{ hostConfig, ... }:
{
  # Run the upstream VS Code Server binaries installed by Remote - SSH.
  programs.nix-ld.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
    authorizedKeysInHomedir = false;
    settings = {
      AllowStreamLocalForwarding = "local";
      AllowTcpForwarding = "local";
      AllowUsers = [ hostConfig.username ];
      AuthenticationMethods = "publickey";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

  services.avahi = {
    enable = true;
    openFirewall = false;
    settings = {
      server.allow-interfaces = [ hostConfig.wiredInterface ];
      publish = {
        disable-publishing = false;
        publish-addresses = true;
      };
    };
  };

  networking.firewall.interfaces."${hostConfig.wiredInterface}" = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 5353 ];
  };

  users.users."${hostConfig.username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICatHPXP4lwqmd/a+2ke60qO6ItrqWSZgFS2/SkXX9TU"
  ];
}
