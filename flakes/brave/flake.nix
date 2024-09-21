{
  description = "A flake that packages the latest nightly release of Brave Browser";

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
      releaseSha = "sha256-wxdd5OC4I5JMjvKI7WCT3Q5lWE6XHiALByOShbAj6T4=";
      archiveSha = "sha256-+SyG978SnI+mRUpqfevCvfV1zl2AzuGn9AVnjST4Y4s=";

      latestRelease = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
        url = "https://api.github.com/repos/brave/brave-browser/releases";
        sha256 = releaseSha;
      }));

      latestNightly =
        builtins.elemAt
        (builtins.filter (release: pkgs.lib.hasPrefix "Nightly" release.name)
          latestRelease)
        0;

      version =
        builtins.elemAt
        (builtins.match "Nightly v([0-9.]+) .*" latestNightly.name)
        0;
      # version = "123123";

      asset = builtins.head (builtins.filter
        (asset: pkgs.lib.hasSuffix "linux-amd64.zip" asset.name)
        latestNightly.assets);
    in {
      packages.brave-browser-nightly = pkgs.stdenv.mkDerivation {
        pname = "brave-browser-nightly";
        inherit version;

        src = pkgs.fetchzip {
          stripRoot = false;
          url = asset.browser_download_url;
          sha256 = archiveSha;
        };

        installPhase = ''
          mkdir -p $out/bin
          cp -r * $out/
          ln -s $out/brave $out/bin/brave

          mkdir -p $out/share/applications
          cat <<EOF >$out/share/applications/brave-browser-nightly.desktop
          [Desktop Entry]
          Name=Brave Browser Nightly
          Exec=$out/bin/brave --enable-features=UseOzonePlatform --ozone-platform=wayland %f
          Type=Application
          EOF
        '';

        meta = with pkgs.lib; {
          description = "Brave Browser Nightly Build";
          homepage = "https://brave.com";
          license = licenses.mpl20;
          platforms = ["x86_64-linux"];
          maintainers = ["lippiece"];
        };
      };

      packages.default = self.packages.${system}.brave-browser-nightly;
    });
}
