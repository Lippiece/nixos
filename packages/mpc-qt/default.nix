let
  pkgs = import <nixos> {};
in {
  mpc-qt = pkgs.qt6Packages.callPackage ./mpc-qt.nix {};
}
