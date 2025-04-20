{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # Didn't find anything useful
    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helpers
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # TODO: build failure
    # nix-alien.url = "github:thiagokokada/nix-alien";

    # My
    zen-browser = {
      url = "./flakes/zen-browser/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    zen-browser,
    # nix-alien,
    ...
  } @ inputs: {
    nixosConfigurations."mothership" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # My configuration
        ./modules/nixos/configuration.nix
        ./modules/nixos/hardware-configuration.nix

        # Home Manager
        inputs.home-manager.nixosModules.default

        ({pkgs, ...}: {
          home-manager.users.lippiece = {pkgs, ...}: {
            home.packages = [
              zen-browser.packages.${pkgs.system}.default
              # nix-alien.packages.${pkgs.system}.default
              inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
              # inputs.nix-alien.packages.${pkgs.system}.nix-alien-ld
              # inputs.nix-alien.packages.${pkgs.system}.nix-alien-find-libs
            ];
          };
        })
      ];
    };
  };
}
