# home/quisiou/variables.nix


{ config, pkgs, ... }:

{
    home.sessionVariables = {
        XDG_CACHE_HOME                  =   "${config.home.homeDirectory}/.cache";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS  =   "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
        UV_PYTHON_PREFERENCE            =   "only-managed";
        QT_LOGGING_RULES                =   "qt.qpa.services.warning=false";
        EDITOR  =   "nvim";
        VISUAL  =   "nvim";
        DICPATH =   "${pkgs.hunspellDicts.en_US}/share/hunspell:${pkgs.hunspellDicts.es_ES}/share/hunspell";
    };
}
