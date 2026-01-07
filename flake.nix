{
  description = "Homeserver flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations."cumulonimbus" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # My configuration
        ./modules/nixos/configuration.nix
        ./modules/nixos/homeserver.nix
        ./modules/nixos/hardware-configuration.nix

        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
