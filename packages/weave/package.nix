# @ts: { lib: Lib; pkgs: Nixpkgs; stdenv: Stdenv; derivation: Derivation; platform: Platform; [key: string]: any }
{
  fetchFromGitHub,
  rustPlatform,
  pkgs,
}:
rustPlatform.buildRustPackage {
  name = "sem";

  src = fetchFromGitHub {
    owner = "ataraxy-labs";
    repo = "weave";
    tag = "v0.2.7";
    hash = "sha256-K10yGylbbwX42dTlkHOHUxnlHoVXSvp9gI0TUmMAHug=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl
    openssl.dev
  ];
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  cargoHash = "sha256-NtoRGvF8FWcQkrmNbeut1cU66ob8iNVpl3WJ35avDBk=";
}
