# home/quisiou/files/dotfiles.nix


{ config, ... }:

let
    configDir = "${config.home.homeDirectory}/.config";
in
{
    home.file = {
        "${configDir}/quickshell/quickapps.json".text = ''
            [
                "steam",
                "firefox",
                "vesktop",
                "gimp",
                "zulip",
                "org.inkscape.Inkscape",
                "spotify",
                "org.musescore.MuseScore"
            ]
        '';
    };
}
