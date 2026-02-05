{ ... }:
{
  programs.ssh.matchBlocks = {
    # Arch Linuxサーバー
    "arch" = {
      hostname = "hosshiiarch.local";
      user = "hosshii";
      forwardAgent = true;
      remoteForwards = [
        {
          bind.port = 50052;
          host.address = "127.0.0.1";
          host.port = 50052;
        }
      ];
    };
  };
}
