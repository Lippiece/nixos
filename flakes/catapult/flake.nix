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
      listSha = "06m5npf4c68i4fmh88ibiydcqdmvnqz790wzna76vkm1b3790a4p";
      archiveSha = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

      releaseList = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
        url = "https://api.github.com/repos/qrrk/Catapult/releases";
        sha256 = listSha;
      }));

      asset = builtins.head (builtins.head releaseList).assets;

      version = (builtins.head releaseList).tag_name;
    in {
      packages.catapult-browser-nightly = pkgs.stdenv.mkDerivation {
        pname = "catapult";
        inherit version;

        src = pkgs.fetchzip {
          stripRoot = false;
          url = asset.browser_download_url;
          sha256 = archiveSha;
        };

        installPhase = ''
          mkdir -p $out/bin
          cp -r * $out/
          ln -s $out/catapult $out/bin/catapult

          mkdir -p $out/share/applications
          cat <<EOF >$out/share/applications/catapult.desktop
          [Desktop Entry]
          Name=Catapult CDDA launcher
          Exec=$out/bin/catapult %f
          Type=Application
          EOF
        '';

        meta = with pkgs.lib; {
          description = "Catapult CDDA launcher";
          homepage = "https://catapult.com";
          license = licenses.mpl20;
          platforms = ["x86_64-linux"];
          maintainers = with maintainers; [];
        };
      };

      packages.default = self.packages.${system}.catapult;
    });
}
