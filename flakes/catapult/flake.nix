{
  description = "A flake that packages the latest release of Catapult CDDA launcher";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      listSha = "sha256-ZFRuLzyDoWqqiL9N+zgGDBoI9fvfdytaldSrIpUkqk4=";
      archiveSha = "sha256:19zfd0lrnp2f3z9z7zpzy7ddc76d6kzk1j1p4kpak794790xr52q";

      releaseList = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
        url = "https://api.github.com/repos/qrrk/Catapult/releases";
        sha256 = listSha;
      }));

      asset = builtins.head (builtins.head releaseList).assets;

      version = (builtins.head releaseList).tag_name;
    in {
      packages.catapult = pkgs.stdenv.mkDerivation {
        pname = "catapult";
        inherit version;

        src = builtins.fetchurl {
          url = asset.browser_download_url;
          sha256 = archiveSha;
        };

        dontUnpack = true;

        propagatedBuildInputs = with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXrender
          xorg.libXrandr
          xorg.libX11
          xorg.libXext
          makeWrapper
          xorg.libxcb
          xorg.libXau
          xorg.libXdmcp
          libGL
          libGLX
          mesa
          udev
        ];

        installPhase = ''
            mkdir -p $out/bin $out/share
            cp $src $out/share/catapult
            chmod +x $out/share/catapult
            chmod 777 $out/share

            # make libraries avaiable
          wrapProgram $out/share/catapult \
            --set LD_LIBRARY_PATH "${
            pkgs.lib.makeLibraryPath [
              pkgs.xorg.libXcursor
              pkgs.xorg.libXi
              pkgs.xorg.libXinerama
              pkgs.xorg.libXrender
              pkgs.xorg.libXrandr
              pkgs.xorg.libX11
              pkgs.xorg.libXext
              pkgs.xorg.libxcb
              pkgs.xorg.libXau
              pkgs.xorg.libXdmcp
              pkgs.libGL
              pkgs.libGLX
              pkgs.mesa
              pkgs.udev
            ]
          }:$LD_LIBRARY_PATH"

            mkdir -p $out/share/applications
            cat <<EOF >$out/share/applications/catapult.desktop
            [Desktop Entry]
            Name=Catapult CDDA launcher
            Exec=/opt/catapult/catapult %f
            Type=Application
            EOF
        '';

        meta = with pkgs.lib; {
          description = "Catapult CDDA launcher";
          homepage = "https://catapult.com";
          license = licenses.mpl20;
          platforms = ["x86_64-linux"];
          maintainers = ["lippiece"];
        };
      };

      packages.default = self.packages.${system}.catapult;
    });
}
