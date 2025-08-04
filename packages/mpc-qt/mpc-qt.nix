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
  version = "unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "8920a8df2979c3a467593c1ec98a0cb3fede3f01";
    sha256 = "1hrj9c25syizmzdmcfixwar22s50r68nh2dxjk6viv7hz4gnxamm";
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
