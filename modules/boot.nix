# modules/boot.nix


{ config, pkgs, ... }:

{
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                efiSupport = true;
                device = "nodev"; # EFI-only, no MBR write
                useOSProber = false; # true if dual-boot another OS
                configurationLimit = 3; # keep last 5 generations
                extraEntries = ''
                    menuentry "UEFI Firmware Settings" {
                        fwsetup
                    }
                '';

                minegrub-theme = {
                    enable = true;
                    boot-options-count = 3;
                };

                # minegrub-world-sel = {
                #     enable = true;
                #     customIcons = with config.system; [
                #         {
                #             inherit name;
                #             lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
                #             lineBottom = "Survival Mode, No Cheats, Version: " + nixos.release;
                #             # Icon: you can use an icon from the remote repo, or load from a local file
                #             imgName = "nixos";
                #             # customImg = builtins.path {
                #             #   path = ./nixos-logo.png;
                #             #   name = "nixos-img";
                #             # };
                #         }
                #     ];
                # };
            };
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
