{ ... }:
{
  imports = [
    ../../modules/home/cli
  ];

  custom.git = {
    name = "Hosshii";
    email = "sao_heath6147.wistre@icloud.com";
    ghq.enable = true;
    wt.enable = true;
    delta.enable = true;
  };
}
