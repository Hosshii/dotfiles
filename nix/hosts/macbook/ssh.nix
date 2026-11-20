{ ... }:
let
  server = import ../hosshii-nixos/host.nix;
  alias = "nixos";
in
{
  programs._1password.sshIntegration.hosts = [ alias ];
  programs.zsh.shellAliases."code-${alias}" = "code --remote ssh-remote+${alias}";

  programs.ssh.settings.${alias} = {
    HostName = "${server.hostname}.local";
    User = server.username;
    ForwardAgent = true;
  };
}
