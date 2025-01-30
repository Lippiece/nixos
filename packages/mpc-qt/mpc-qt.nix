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
  version = "unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "838242513a60dfe14352205cbe7802b98aebbce4";
    sha256 = "16rpbf98by9vlwyyzxdhhgkcpmlfkx040wzkk0nygr7rc65jz1fj";
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
