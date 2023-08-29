{
  description = "NixOS configuration for the homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:/nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, ... }@inputs: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ emacs-overlay.overlay ];
      };
    in {

      nixosConfigurations = {
        bifrost = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
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
