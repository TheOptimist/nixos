{
  description = "NixOS configuration for the homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, impermanence, home-manager, ... }@inputs: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nix-vscode-extensions.overlays.default
          inputs.emacs-overlay.overlay
          (import ./overlays/vivaldi.nix)
          (import ./overlays/logitech.nix)
        ];
      };
    in {

      nixosConfigurations = {
        bifrost = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            impermanence.nixosModules.impermanence
            (import ./machines/bifrost/configuration.nix)

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.george = (import ./users/george { inherit system pkgs inputs; });
            }

          ];
        };
      };
    };

}
