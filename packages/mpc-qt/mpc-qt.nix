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
  version = "unstable-2025-04-20";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "e7e0e3b14a5fbe6a1f836737aa2ecda9f92b5bda";
    sha256 = "1pk9xf2mk61q4xpd7asxwlkm7mv0qiwvj8l0lp58xhvw930f01rw";
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
