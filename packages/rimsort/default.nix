let
  pkgs = import <nixpkgs> {};
in {
  rimsort = pkgs.callPackage ./package.nix {};
}
