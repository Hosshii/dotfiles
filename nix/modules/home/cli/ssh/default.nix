{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {

      # 全ホスト共通設定
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = true;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "no";
      };
    };
  };
}
