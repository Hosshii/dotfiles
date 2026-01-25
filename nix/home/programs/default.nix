{ gitConfig, ... }: {
  imports = [
    (import ./bat/default.nix)
    (import ./fzf/default.nix)
    (import ./git/default.nix { config = gitConfig; })
    (import ./zoxide/default.nix)
  ];
}
