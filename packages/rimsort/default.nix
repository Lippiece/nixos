let
  pkgs = import <nixpkgs> {};
in {
  rimsort = pkgs.callPackage ./rimsort.nix {};
}
