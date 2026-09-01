# modules/security.nix


{ ... }:

{
    security = {
        polkit.enable = true;
        rtkit.enable = true;
    };
}
