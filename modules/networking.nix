# modules/networking.nix


{ ... }:

{
    networking = {
        wireless.iwd.enable = true;
        networkmanager = {
            enable = true;
            wifi.backend = "iwd";
        };
    };
}
