{
  description = "Nixos config flake";

  inputs = {
    # TODO: https://nixpk.gs/pr-tracker.html?pr=512989
    nixpkgs.url = "github:nixos/nixpkgs/9e8521efd74659aaea12e3990147addb86d04a22";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    phoenix = {
      url = "git+https://gitlab.com/celenityy/Phoenix?ref=pages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helpers
    impermanence.url = "github:nix-community/impermanence";
    nix-alien.url = "github:thiagokokada/nix-alien";

    typenix = {
      url = "github:ryanrasti/typenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-throne.url = "github:TomaSajt/nixpkgs/throne";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations."mothership" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {
          disabledModules = ["programs/throne.nix"];
          imports = [
            "${inputs.nixpkgs-throne}/nixos/modules/programs/throne.nix"
          ];
          nixpkgs.overlays = [
            (final: prev: {
              throne = inputs.nixpkgs-throne.legacyPackages.${system}.throne;
            })
          ];
        }

        # My configuration
        ./modules/nixos/configuration.nix
        ./modules/nixos/persistence.nix
        ./modules/nixos/hardware-configuration.nix

        inputs.home-manager.nixosModules.default

        inputs.impermanence.nixosModules.impermanence
        inputs.phoenix.nixosModules.default
      ];
    };
  };
}
