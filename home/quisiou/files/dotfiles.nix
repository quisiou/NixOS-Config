# home/quisiou/files/dotfiles.nix

{ config, pkgs, lib, ... }:

{
    home.file = {
        "Dotfiles/quickshell/shell/quickapps.json".text = ''
            [
                "codium",
                "firefox",
                "vesktop",
                "steam",
                "gimp",
                "org.inkscape.Inkscape",
                "spotify",
                "org.musescore.MuseScore"
            ]
        '';
    };
}