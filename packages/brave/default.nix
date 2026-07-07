{pkgs ? import <nixpkgs> {}}: {
  brave = pkgs.callPackage ./package.nix {};
}
