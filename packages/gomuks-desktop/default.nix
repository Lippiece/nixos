{pkgs ? import <nixpkgs> {}}: {
  gomuks-desktop = pkgs.callPackage ./package.nix {};
}
