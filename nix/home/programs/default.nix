{ gitConfig, ... }: {
  imports = [
    (import ./bat/default.nix)
    (import ./fzf/default.nix)
    (import ./git/default.nix { config = gitConfig; })
    (import ./tmux/default.nix)
    (import ./zoxide/default.nix)
  ];
}
