{ ... }:
{
  programs.ssh.settings = {
    # Arch Linuxサーバー
    "arch" = {
      HostName = "hosshiiarch.local";
      User = "hosshii";
      ForwardAgent = true;
      RemoteForward = [
        {
          bind.port = 50052;
          host.address = "127.0.0.1";
          host.port = 50052;
        }
      ];
    };
  };
}
