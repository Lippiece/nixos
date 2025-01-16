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
      releaseSha = "sha256-37h3xkIOi0bw1OvQxrf5c3+Chb2SwXAhr2AwfxYc2ak=";
      archiveSha = "sha256-7p0Ph4PEFd/4A12yACs8TEhB7HzX5LgZWNhlJ+DKWS0=";

      latestRelease = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
        url = "https://api.github.com/repos/brave/brave-browser/releases";
        sha256 = "0lwsc5cdxvaz60my230ia8lqlr9na059y959j4dl5r62bz6cwkl1";
      }));

      latestNightly =
        builtins.elemAt
        (builtins.filter (release: pkgs.lib.hasPrefix "Nightly" release.name)
          latestRelease)
        1; # if error, change to 1

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
