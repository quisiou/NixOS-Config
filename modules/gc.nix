# modules/gc.nix

{ config, pkgs, lib, ... }:

{
    nix.gc = {
        automatic = true;
        dates = "Monday *-*-* 09:00:00";
        options = "--delete-old";
    };
}
