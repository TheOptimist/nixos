{
  description = "NixOS configuration for the homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {

    nixosConfigurations = {
      bifrost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./machines/bifrost/configuration.nix)
        ];
      };
    };

  };

}
