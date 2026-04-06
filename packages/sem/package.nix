{
  fetchFromGitHub,
  rustPlatform,
  pkgs,
}:
rustPlatform.buildRustPackage (finalAttrs: rec {
  name = "sem";

  repo = fetchFromGitHub {
    owner = "ataraxy-labs";
    repo = "sem";
    tag = "latest";
    hash = "sha256-4D6BmtwpZcKeV6vCpbzOfs7dY3znUGjOapjGGVTOx3Y=";
  };

  src = "${repo}/crates";

  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl
    openssl.dev
  ];
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  cargoHash = "sha256-Z0i1yGumKde8qb3Hd1PTXWS/CputhqbRZ4deIf0vl4s=";
})
