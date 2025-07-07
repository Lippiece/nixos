{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    phoenix = {
      url = "git+https://codeberg.org/celenity/Phoenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helpers
    impermanence.url = "github:nix-community/impermanence";
    nix-alien.url = "github:thiagokokada/nix-alien";

    weirdrock-pkgs.url = "github:weirdrock/nixpkgs/init-rimsort";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # import your normal nixpkgs with allowUnfree turned on
    pkgsUnfree = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };

    # now pull in the weirdrock flake against that
    rimsortUnfree =
      import inputs.weirdrock-pkgs
      {
        inherit pkgsUnfree; # so that it sees the unfree‐enabled pkgs
        system = pkgsUnfree.system;
        config = {
          allowUnfree = true;
        };
      };
  in {
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
              rimsortUnfree.rimsort
            ];
          };
        })

        inputs.phoenix.nixosModules.default
      ];
    };
  };
}
