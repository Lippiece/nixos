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
}:
stdenv.mkDerivation {
  pname = "mpc-qt";
  version = "unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "88a0e393e277c707ed72c31c7e8ed9c4d2fb2f53";
    sha256 = "13ipicx93ynmb6zc4cwi2g5pzld7id1rllsynipgfl5f8ib5zb1h";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    qttools
    qtbase
    wrapQtAppsHook
    qt6Packages.qtsvg
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
