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
    flake-utils.lib.eachDefaultSystem (
      system: let
        archiveSha256 = "sha256-RpHQQ3Wf3NoYvXk1b3q2NJo2q3QTMp/CMli8h5++XLk=";

        pkgs = nixpkgs.legacyPackages.${system};

        owner = "brave";
        repo = "brave-browser";

        latestRelease = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
          url = "https://api.github.com/repos/${owner}/${repo}/releases";
          sha256 = "sha256-TAWRs3bfDPQ4nGXcSPUVUYnPnCfCk0FFEmiZn9l1NfA=";
        }));

        latestNightly = builtins.head (builtins.filter
          (
            release:
              pkgs.lib.hasPrefix "Nightly" release.name
          )
          latestRelease);

        version = builtins.elemAt (builtins.match "Nightly v([0-9.]+) .*" latestNightly.name) 0;

        asset = builtins.head (builtins.filter
          (
            asset:
              pkgs.lib.hasSuffix "linux-amd64.zip" asset.name
          )
          latestNightly.assets);
      in {
        packages.brave-browser-nightly = pkgs.stdenv.mkDerivation {
          pname = "brave-browser-nightly";
          inherit version;

          src = pkgs.fetchzip {
            stripRoot = false;
            url = asset.browser_download_url;
            sha256 = archiveSha256;
          };

          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/
            ln -s $out/brave $out/bin/brave

            mkdir -p $out/share/applications
            cat <<EOF >$out/share/applications/brave-browser-nightly.desktop
            [Desktop Entry]
            Name=brave-browser-nightly
            Exec=$out/bin/brave %f
            Type=Application
            EOF
          '';

          meta = with pkgs.lib; {
            description = "Brave Browser Nightly Build";
            homepage = "https://brave.com";
            license = licenses.mpl20;
            platforms = ["x86_64-linux"];
            maintainers = with maintainers; [];
          };
        };

        packages.default = self.packages.${system}.brave-browser-nightly;
      }
    );
}
