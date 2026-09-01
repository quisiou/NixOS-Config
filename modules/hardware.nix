# modules/hardware.nix


{ ... }:

{
    hardware = {
        bluetooth.enable = true;
        steam-hardware.enable = true;
        uinput.enable = true;
        alsa.enablePersistence = true;
    };
}
