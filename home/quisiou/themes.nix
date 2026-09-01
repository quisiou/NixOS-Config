# home/quisiou/themes.nix


{ pkgs, ... }:

{
    gtk = {
        enable = true;
        colorScheme = "dark";
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            size = 24;
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "gtk3";
    };
}
