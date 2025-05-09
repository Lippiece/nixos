{
  lib,
  python3Packages,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
  stdenv,
  todds,
  steamPackages,
}:
python3Packages.buildPythonApplication rec {
  pname = "rimsort";
  version = "unstable-2025-05-08";

  src = fetchFromGitHub {
    owner = "RimSort";
    repo = "RimSort";
    rev = "194843872239c2ff3be122ee1c7141b7fa3d75ab";
    sha256 = "1rx6x0i3ifrg4k0hqpsfjly9p9hcvyr1jbfgzr3bcyc3g8jb6xwk";
  };

  patches = [
    ./make-nix-compatible.patch
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools
    imagemagick
    copyDesktopItems
  ];

  python-deps = with python3Packages; [
    beautifulsoup4
    gitpython
    imageio
    loguru
    lxml
    mypy
    natsort
    nuitka
    platformdirs
    psutil
    pygithub
    pyperclip
    pyside6
    pytz
    requests
    steam
    steamfiles
    steamworks
    toposort
    watchdog
    xmltodict
  ];

  propagatedBuildInputs = [todds] ++ python-deps;

  preBuild = ''
    cat > setup.py <<EOF
    from setuptools import setup, find_packages

    def main():
        from app import __main__

    with open("requirements.txt") as f:
        install_requires = f.read().splitlines()

    setup(
        name="rimsort",
        packages=find_packages(),
        version="0.1.0",
        install_requires=install_requires,
        entry_points={
            "console_scripts": ["rimsort=app.__main__:main"],
        },
    )
    EOF
  '';

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/{48x48,128x128}/apps
    convert $src/themes/default-icons/AppIcon_a.png -resize 48x48 $out/share/icons/hicolor/48x48/apps/rimsort.png
    convert $src/themes/default-icons/AppIcon_a.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/rimsort.png

    ln -s $src/themes $out/lib/themes
    ln -s $src/libs/SteamworksPy_${stdenv.hostPlatform.uname.processor}.so $out/lib/SteamworksPy.so
    ln -s $src/libs/libsteam_api.so $out/lib/libsteam_api.so
    ln -s ${todds}/bin/todds $out/bin/
    ln -s ${steamPackages.steamcmd}/bin/steamcmd $out/bin/
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "RimSort";
      exec = meta.mainProgram;
      icon = "rimsort";
      desktopName = "RimSort";
      comment = meta.description;
      categories = ["Game" "Utility"];
    })
  ];

  doCheck = false;

  meta = with lib; {
    description = "An open-source RimWorld mod manager";
    homepage = "https://github.com/RimSort/RimSort";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [vinnymeller];
    mainProgram = "rimsort";
  };
}
