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

        hyprland.url = "github:hyprwm/Hyprland/v0.56.0";
        hyprtasking = {
            url = "github:raybbian/hyprtasking";
            inputs.hyprland.follows = "hyprland";
        };
        hyprglass-src = {
            url = "github:hyprnux/hyprglass";
            flake = false;
        };

        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        steam-config-nix = {
            url = "github:different-name/steam-config-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, home-manager, nix-vscode-extensions, steam-config-nix, ... }:
    let
        hostSystem = "x86_64-linux";
        pkgs = import nixpkgs { system = hostSystem; };
    in
    {
        packages.${hostSystem} = {
            hyprglass = pkgs.stdenv.mkDerivation {
                pname = "hyprglass";
                version = "unstable";
                src = inputs.hyprglass-src;

                nativeBuildInputs = [
                    pkgs.pkg-config
                    pkgs.wayland-scanner
                ];
                buildInputs = [
                    inputs.hyprland.packages.${hostSystem}.hyprland
                ] ++ inputs.hyprland.packages.${hostSystem}.hyprland-unwrapped.buildInputs;

                installPhase = ''
                    mkdir -p $out/lib
                    cp hyprglass.so $out/lib/libhyprglass.so
                '';
            };
        };

        nixosConfigurations.chirimbolo = nixpkgs.lib.nixosSystem {
            system = hostSystem;
            specialArgs = { inherit inputs; };
            modules = [
                ./hosts/chirimbolo/configuration.nix
                home-manager.nixosModules.home-manager
                inputs.steam-config-nix.nixosModules.default
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
