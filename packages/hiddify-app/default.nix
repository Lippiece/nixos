let
  pkgs = import <nixpkgs> {};
in {
  hiddify-app = pkgs.callPackage ./package.nix {};
}
