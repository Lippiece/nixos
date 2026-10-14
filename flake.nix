{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helpers
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typenix = {
      url = "github:ryanrasti/typenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations."mothership" = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          system
          ;
      };
      modules = [
        # My configuration
        ./modules/nixos/configuration.nix
        ./modules/nixos/persistence.nix
        ./modules/nixos/hardware-configuration.nix

        inputs.home-manager.nixosModules.default

        inputs.impermanence.nixosModules.impermanence
      ];
    };
  };
}
