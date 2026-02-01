{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {

      # 全ホスト共通設定
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };

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
  };
}
