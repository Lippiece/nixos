let
  pkgs = import <nixpkgs> {};
in {
  mpc-qt = pkgs.qt6Packages.callPackage ./mpc-qt.nix {};
}
