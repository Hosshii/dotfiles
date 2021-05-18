#!/bin/sh

# echo "update and upgrade opam"
# opam update && opam upgrade

echo "install packages"
# cat ./scripts/package.txt | opam install
opam install . --deps-only

satyrographos install
