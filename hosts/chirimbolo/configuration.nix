# hosts/chirimbolo/configuration.nix


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix

        # Modules
        ../../modules/boot.nix
        ../../modules/fonts.nix
        ../../modules/gc.nix
        ../../modules/hardware.nix
        ../../modules/locale.nix
        ../../modules/networking.nix
        ../../modules/packages.nix
        ../../modules/programs.nix
        ../../modules/security.nix
        ../../modules/services.nix
        ../../modules/users.nix

        # Specific file with steam launch options for every game
        ./steam-games.nix
    ];


    # --- Boot kernel parameters -----------------------------------------
    boot.kernelParams = [
        "nvidia_drm.modeset=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];


    # --- Hybrid NVIDIA/AMD graphics -------------------------------------
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;          # needed for suspend/resume
        powerManagement.finegrained = false;    # set true if you want PRIME offload on-demand
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;

        prime = {
            offload = {
                enable = true;              # GPU on-demand (saves battery)
                enableOffloadCmd = true;    # adds `nvidia-offload` helper
            };

            amdgpuBusId    = "PCI:101:0:0"; # 65:00.0 → 0x65 = 101 decimal
            nvidiaBusId    = "PCI:1:0:0";   # 01:00.0 → already decimal
        };
    };

    # amdgpu needs hardware.opengl (renamed to graphics in 24.05+)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
            rocmPackages.clr.icd
        ];
    };

    # Load both amdgpu + nvidia
    services.xserver.videoDrivers = [ "nvidia" ];


    # --- Add flakes support ---------------------------------------------
    nix.settings.experimental-features = [ "nix-command" "flakes" ];


    # --- Networking hostname --------------------------------------------
    networking.hostName = "chirimbolo";


    # --- System state version -------------------------------------------
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05";
}
