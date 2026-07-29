{
  stdenv,
  copyDesktopItems,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  glib,
  gtk3,
  libgbm,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  systemdLibs,
  xorg_sys_opengl,
}:
stdenv.mkDerivation rec {
  name = "gomuks-desktop-${version}";
  version = "0.2607.0";

  src = fetchurl {
    url = "https://github.com/gomuks/gomuks/releases/download/v0.2607.0/gomuks-desktop_26.07.0_amd64.deb";
    sha256 = "17wxbacqwk3lraikcczk9x9vyk2ms33ija8ycfw5v2c93cvs10xs";
  };

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups.lib
    dbus.lib
    glib
    gtk3
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    systemdLibs
    xorg_sys_opengl
  ];

  nativeBuildInputs = [
    dpkg
    copyDesktopItems
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R ./usr/* $out/
    # ln -s $out/usr/bin/gomuks-desktop $out/bin/

    runHook postInstall
  '';
}
