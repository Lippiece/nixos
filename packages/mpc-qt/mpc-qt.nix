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
  version = "unstable-2025-01-18";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "1587455604749878b3bd95b4cc4d36bc05680504";
    sha256 = "0yvpw3fnh1l6dhg12adqnmxnd8mn4ccaac6wgkc05gg0x2an82as";
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
