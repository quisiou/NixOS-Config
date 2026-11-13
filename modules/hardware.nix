# modules/hardware.nix


{ ... }:

{
    hardware = {
        alsa.enablePersistence = true;
        bluetooth.enable = true;
        openrazer = {
            enable = true;
            users = [ "quisiou" ];
            devicesOffOnScreensaver = true;
            batteryNotifier = {
                enable = true;
                percentage = 15;
            };
        };
        sane.enable = true;
        steam-hardware.enable = true;
        uinput.enable = true;
    };
}
