# modules/programs.nix

{ config, pkgs, lib, inputs, ... }:

{
    imports = [
        ./proton.nix
    ];

    programs = {
        gpu-screen-recorder.enable = true;      # Self-explanatory, innit?
        hyprland = {           		            # Default window manager
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
            withUWSM = true;
            xwayland.enable = true;
        };
        steam = {                  	            # Gaming platform
            enable = true;
            remotePlay.openFirewall = true;
            gamescopeSession.enable = true; 	# better gaming performance
            extraCompatPackages = with pkgs; [
                proton-ge-bin
                ge-proton9-24
                ge-proton10-28
            ];
            config = {
                enable = true;
                onSteamRunning = "close";
            };
        };
        gamemode.enable = true;                 # Gamemode for steam games
        zsh.enable = true;
        obs-studio = {
            enable = true;
            enableVirtualCamera = true;
        };
        nix-ld = {                              # Run unpatched dynamic binaries on NixOS.
            enable = true;
            libraries = with pkgs; [
                stdenv.cc.cc.lib   # libstdc++ — needed by nearly everything (numpy, pandas, torch...)
                zlib
                openssl
                curl
                expat
                libGL
                glib
                icu
                fuse3
                nss
                libx11
                libxext
                libxrender
                fontconfig
                freetype
            ];
        };
    };
}
