# home/quisiou/home.nix


{ config, pkgs, lib, ... }:

{
    imports = [
        ./packages.nix
        ./programs.nix
        ./scripts.nix
        ./services.nix
        ./theme.nix
        ./variables.nix
        ./xdg-desktop.nix
        ./xdg-mime.nix

        # Nix-managed files
        ./files/dotfiles.nix
        ./files/dolphin-emu.nix
        ./files/pcsx2.nix
        ./files/rpcs3.nix
        ./files/steam.nix
    ];

    home = {
        username = "quisiou";
        homeDirectory = "/home/quisiou";
        stateVersion = "26.05";
    };

    programs.home-manager.enable = true;
}
