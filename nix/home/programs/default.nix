{ gitConfig, ... }: {
  imports = [
    (import ./bat/default.nix)
    (import ./eza/default.nix)
    (import ./fzf/default.nix)
    (import ./git/default.nix { config = gitConfig; })
    (import ./htop/default.nix)
    (import ./jq/default.nix)
    (import ./ripgrep/default.nix)
    (import ./tmux/default.nix)
    (import ./zoxide/default.nix)
  ];
}
