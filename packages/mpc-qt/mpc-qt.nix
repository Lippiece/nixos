{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qttools,
  qtbase,
  qt6Packages,
  mpv,
  wrapQtAppsHook,
  gitUpdater,
  boost,
}:
stdenv.mkDerivation {
  pname = "mpc-qt";
  version = "unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "36f6e34607183512d157e9a8ee9f382674580f2d";
    sha256 = "03sjjwv16xas0g459rj5ll17wfx9k38z74zdc7flpyz0ckn9p44m";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qttools
    qtbase
    wrapQtAppsHook
    qt6Packages.qtsvg
    boost
  ];

  buildInputs = [
    mpv
  ];

  buildPhase = ''
    cmake .
    make -j`nproc`
    make install
  '';

  passthru.updateScript = gitUpdater {rev-prefix = "v";};

  meta = with lib; {
    description = "Media Player Classic Qute Theater";
    homepage = "https://mpc-qt.github.io";
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "mpc-qt";
  };
}
