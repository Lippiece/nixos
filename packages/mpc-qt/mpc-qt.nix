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
  version = "unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "078c285ef984f35f341bf4c07cbadff300127f26";
    sha256 = "1d4xp0s5swsp399x8hqdaa5hhxsch7apr128a1a31g0n3a3rwada";
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
