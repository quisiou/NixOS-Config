# modules/boot.nix


{ pkgs, ... }:

{
    boot = {
        loader = {
            systemd-boot.enable = false;
            grub = {
                enable = true;
                efiSupport = true;
                device = "nodev"; # EFI-only, no MBR write
                useOSProber = false; # true if dual-boot another OS
                configurationLimit = 5; # keep last 5 generations
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
