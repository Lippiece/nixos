{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qmake,
  qttools,
  qtbase,
  qt6Packages,
  mpv,
  wrapQtAppsHook,
  gitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "mpc-qt";
  version = "unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "40d9d2973ea8df8a59464a51ceb772764adcbabf";
    sha256 = "1nzf9l41irnv75bkvwf2qa0vjvkdg2ag65nafr848k9jbz382f1f";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    wrapQtAppsHook
    qt6Packages.qtsvg
  ];

  buildInputs = [
    mpv
  ];

  postPatch = ''
    substituteInPlace lconvert.pri --replace "qtPrepareTool(LCONVERT, lconvert)" "qtPrepareTool(LCONVERT, lconvert, , , ${qttools}/bin)"
  '';

  postConfigure = ''
    substituteInPlace Makefile --replace ${qtbase}/bin/lrelease ${qttools.dev}/bin/lrelease
  '';

  qmakeFlags = [
    "MPCQT_VERSION=${version}"
  ];

  passthru.updateScript = gitUpdater {rev-prefix = "v";};

  meta = with lib; {
    description = "Media Player Classic Qute Theater";
    homepage = "https://mpc-qt.github.io";
    license = licenses.gpl2;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [romildo];
    mainProgram = "mpc-qt";
  };
}
