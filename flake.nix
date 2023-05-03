{
  description = "NixOS configuration for the homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: {

    nixosConfigurations = {
      bifrost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./machines/bifrost/configuration.nix)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.george = (import ./users/george);
          }
        ];
      };
    };

  };

}
