{ pkgs, config, ... }:
{
  home.packages = [ pkgs.sccache ];

  programs.zsh.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
  };

  xdg.dataFile."cargo/config.toml".text = ''
    [build]
    rustc-wrapper = "${pkgs.sccache}/bin/sccache"
  '';
}
