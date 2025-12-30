{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    phoenix = {
      url = "git+https://codeberg.org/celenity/Phoenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # Helpers
    impermanence.url = "github:nix-community/impermanence";
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations."mothership" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # My configuration
        ./modules/nixos/configuration.nix
        ./modules/nixos/hardware-configuration.nix

        inputs.home-manager.nixosModules.default

        inputs.phoenix.nixosModules.default

        inputs.impermanence.nixosModules.impermanence
      ];
    };
  };
}
