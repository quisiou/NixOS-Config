# modules/boot.nix

{ config, pkgs, lib, ... }:

{
    boot = {
        loader = {
            systemd-boot = {
                enable = true;
                configurationLimit = 5; # Max number of generations showed on boot
            };
            efi.canTouchEfiVariables = true;
        };

        # Use latest kernel.
        kernelPackages = pkgs.linuxPackages_latest;

        kernel.sysctl = { "kernel.printk" = "3 4 1 3"; };
        kernelParams = [ "loglevel=3" ];
        kernelModules = [
            "hid_playstation"
        ];
    };
}
