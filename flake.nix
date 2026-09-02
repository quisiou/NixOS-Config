# flake.nix


{
    description = "chirimbolo NixOS configuration";

    inputs = {
        nixpkgs.url         =   "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url  =   "github:NixOS/nixpkgs/nixos-26.05";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";   # Avoids a second nixpkgs evaluation
        };

        hyprland.url = "github:hyprwm/Hyprland/v0.56.1";
        hyprtasking = {
            url = "github:raybbian/hyprtasking";
            inputs.hyprland.follows = "hyprland";
        };

        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        steam-config-nix = {
            url = "github:different-name/steam-config-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        minegrub-theme = {
            url = "github:Lxtharia/minegrub-theme";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        minegrub-world-sel-theme = {
            url = "github:Lxtharia/minegrub-world-sel-theme";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs @ { self, nixpkgs, home-manager, nix-vscode-extensions, steam-config-nix, ... }: {
        nixosConfigurations.chirimbolo = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
                ./hosts/chirimbolo/configuration.nix
                home-manager.nixosModules.home-manager
                inputs.steam-config-nix.nixosModules.default
                inputs.minegrub-theme.nixosModules.default
                inputs.minegrub-world-sel-theme.nixosModules.default
                {
                    nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = { inherit inputs; };
                    home-manager.users.quisiou = import ./home/quisiou/home.nix;
                }
            ];
        };
    };
}
