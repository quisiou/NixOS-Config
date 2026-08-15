# home/quisiou/variables.nix


{ config, pkgs, lib, ... }:

{
    home.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
        EDITOR = "nvim";
        VISUAL = "nvim";
        UV_PYTHON_PREFERENCE = "only-managed";
        DICPATH = "${pkgs.hunspellDicts.en_US}/share/hunspell:${pkgs.hunspellDicts.es_ES}/share/hunspell";
    };
}
