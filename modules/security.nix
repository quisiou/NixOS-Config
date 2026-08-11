# modules/security.nix

{ config, pkgs, lib, ... }:

{
    security = {
        polkit.enable = true;
        rtkit.enable = true;
    };
}
