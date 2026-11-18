{ pkgs }:
let
  # Update rev and hash together; both agents use the same upstream procedure.
  mattPocockSkills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "5863806dd4e15c63174bee4e7515a4256792ecfa";
    hash = "sha256-AYSRCvBL8TDDdW3rgKu2T7gl4YYDoDId0jYbabEFyfs=";
  };
in
{
  grill-me = "${mattPocockSkills}/skills/productivity/grill-me";
  grilling = "${mattPocockSkills}/skills/productivity/grilling";
}
