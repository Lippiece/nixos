{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brave-nightly = {
      url = "./flakes/brave/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser.url = "./flakes/zen-browser/";
  };

  outputs = {
    self,
    nixpkgs,
    brave-nightly,
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
          # Make Brave Browser Nightly available system-wide
          environment.systemPackages = [brave-nightly.packages.${pkgs.system}.default];

          home-manager.users.lippiece = {pkgs, ...}: {
            home.packages = [zen-browser.packages.${pkgs.system}.specific];
          };
        })
      ];
    };
  };
}
