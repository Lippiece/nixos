{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-alien.url = "github:thiagokokada/nix-alien";

    # My
    zen-browser = {
      url = "./flakes/zen-browser/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    zen-browser,
    ...
  } @ inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # My configuration
        /home/lippiece/.config/nixos/modules/nixos/configuration.nix
        /home/lippiece/.config/nixos/modules/nixos/hardware-configuration.nix

        # Home Manager
        inputs.home-manager.nixosModules.default

        ({pkgs, ...}: {
          home-manager.users.lippiece = {pkgs, ...}: {
            home.packages = [
              zen-browser.packages.${pkgs.system}.default
              inputs.nix-alien.packages.${pkgs.system}.default
              # inputs.nix-alien.packages.${pkgs.system}.nix-alien-ld
              # inputs.nix-alien.packages.${pkgs.system}.nix-alien-find-libs
            ];
          };
        })
      ];
    };
  };
}
