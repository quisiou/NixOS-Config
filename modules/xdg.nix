# modules/xdg.nix

{ config, pkgs, lib, ... }:

{
    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
        ];
        config.common.default = "*";
    };
}
