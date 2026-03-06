{
  stdenv,
  lib,
  makeDesktopItem,
  pkgs ? import <nixpkgs> {},
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
}:
stdenv.mkDerivation rec {
  name = "catapult";
  version = "25.11a";

  src = fetchurl {
    url = "https://github.com/qrrk/Catapult/releases/download/25.11a/catapult-linux-x64-25.11a";
    hash = "sha256-tpEHlXNCP+jaaExbR+xsNFxkdLJ+07HFAnM9azClxO0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = with pkgs; [
    libXcursor
    libXi
    libXinerama
    libXrender
    libGL
    libX11
    libXext
    libXrandr

    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libgcc.lib
    udev

    freetype
    libz
  ];

  binaryRPath = lib.makeLibraryPath buildInputs;

  # Skip
  unpackPhase = "true";

  installPhase = ''
    runHook preInstall
    install -m755 -D ${src} $out/bin/catapult
    runHook postInstall
  '';

  postPhases = ["postPatchelf"];
  postPatchelf = ''
    patchelf $out/bin/catapult --add-rpath ${binaryRPath}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "catapult";
      desktopName = "catapult";
      exec = "catapult";
    })
  ];
}
