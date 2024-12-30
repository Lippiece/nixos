{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) buildFHSUserEnv;
in
  buildFHSUserEnv {
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
        SDL2_image_2_0.out
        SDL2_mixer_2_0.out
        SDL2_ttf.out
        libgcc.lib
        udev

        freetype.out
        libz.out
      ];
    runScript = "/home/lippiece/.config/nixos/packages/catapult/catapult-linux-x64-24.11a";
  }
