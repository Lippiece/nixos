{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) buildFHSEnv;
in
  buildFHSEnv {
    name = "catapult";
    targetPkgs = pkgs:
      with pkgs; [
        libXcursor.out
        libXi.out
        libXinerama.out
        libXrender.out
        libGL.out
        libX11.out
        libXext.out
        libXrandr.out

        SDL2.out
        SDL2_image.out
        SDL2_mixer.out
        SDL2_ttf.out
        libgcc.lib
        udev

        freetype.out
        libz.out
      ];
    runScript = "/home/lippiece/.config/nixos/packages/catapult/Dabdoob-linux.x86_64";
  }
