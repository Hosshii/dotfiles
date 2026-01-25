{ gitConfig, ... }: {
  imports = [
    (import ./git/default.nix { config = gitConfig; })
    (import ./bat/default.nix)
  ];
}
