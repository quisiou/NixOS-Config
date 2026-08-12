# home/quisiou/home.nix


{ config, pkgs, lib, ... }:

{
    imports = [
        ./files.nix
        ./packages.nix
        ./programs.nix
        ./scripts.nix
        ./services.nix
        ./theme.nix
        ./variables.nix
        ./xdg-desktop.nix
        ./xdg-mime.nix
    ];

    home = {
        username = "quisiou";
        homeDirectory = "/home/quisiou";
        stateVersion = "26.05";
    };

    programs.home-manager.enable = true;
}
