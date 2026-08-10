# modules/hardware.nix

{ config, pkgs, lib, ... }:

{
    hardware = {
        bluetooth.enable = true;
        steam-hardware.enable = true;
        uinput.enable = true;
    };
}
