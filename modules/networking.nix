# modules/networking.nix

{ config, pkgs, lib, ... }:

{
    networking = {
        wireless.iwd.enable = true;
        networkmanager = {
            enable = true;
            wifi.backend = "iwd";
        };
    };
}
