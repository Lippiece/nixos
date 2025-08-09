{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) buildFHSEnv;
in
  buildFHSEnv {
    name = "catapult";
    targetPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor.out
        xorg.libXi.out
        xorg.libXinerama.out
        xorg.libXrender.out
        libGL.out
        xorg.libX11.out
        xorg.libXext.out
        xorg.libXrandr.out

        SDL2.out
        SDL2_image.out
        SDL2_mixer.out
        SDL2_ttf.out
        libgcc.lib
        udev

        freetype.out
        libz.out
      ];
    runScript = "/home/lippiece/.config/nixos/packages/catapult/catapult-linux-x64-24.11a";
  }
