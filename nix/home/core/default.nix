{ gitConfig, ... }:
{
  imports = [
    ./bat/default.nix
    ./dust/default.nix
    ./eza/default.nix
    ./fd/default.nix
    ./fzf/default.nix
    ./ghq/default.nix
    ./htop/default.nix
    ./jq/default.nix
    ./onefetch/default.nix
    ./ripgrep/default.nix
    ./sccache/default.nix
    ./starship/default.nix
    ./tmux/default.nix
    ./tokei/default.nix
    ./tree/default.nix
    ./zoxide/default.nix
    ./zsh/default.nix

    (import ./git/default.nix { config = gitConfig; })
  ];
}
