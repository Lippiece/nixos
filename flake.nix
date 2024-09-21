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

    # catapult = {
    #   url = "./flakes/catapult/";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    brave-nightly,
    # catapult,
    ...
  } @ inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        /home/lippiece/.config/nixos/modules/nixos/configuration.nix
        /home/lippiece/.config/nixos/modules/nixos/hardware-configuration.nix
        inputs.home-manager.nixosModules.default

        ({pkgs, ...}: {
          # Make Brave Browser Nightly available system-wide
          environment.systemPackages = [brave-nightly.packages.${pkgs.system}.default];

          # home-manager.users.lippiece = {pkgs, ...}: {
          #   home.packages = [catapult.packages.${pkgs.system}.default];
          # };
        })
      ];
    };
  };
}
