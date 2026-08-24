# home/quisiou/wayland.nix


{ config, pkgs, lib, inputs, ... }:

let
    dotsDir = "${config.home.homeDirectory}/Dotfiles";
in
{
    wayland.windowManager.hyprland = {
        enable = true;

        package = null;        # reuse the package from programs.hyprland
        portalPackage = null;  # reuse the portal from programs.hyprland — avoids duplication
        systemd.enable = false; # UWSM already starts the session target; this would conflict

        configType = "lua";
        extraConfig = ''
            ------ LOAD ACTIVE ELYSIAN THEME ------------------------
            theme = require("theme")

            ------ LOAD ENV VARIABLES (DEFAULT AND/OR CUSTOM) -------
            require("default.env")
            require("user.env")

            ------ LOAD VARIABLES (DEFAULT AND/OR CUSTOM) -----------
            require("default.variables")
            require("user.variables")

            ------ LOAD DEFAULT CONFIGURATION -----------------------
            require("default.monitors")
            require("default.look_and_feel")
            require("default.input")
            require("default.keybinds")
            require("default.windowrules")
            require("default.autostart")

            ----- LOAD USER OVERRIDES -------------------------------
            require("user.monitors")
            require("user.look_and_feel")
            require("user.input")
            require("user.keybinds")
            require("user.windowrules")
            require("user.autostart")
        '';

        plugins = [
            inputs.hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking
            inputs.self.packages.x86_64-linux.hyprglass
        ];
    };

    home.file = {
        ".config/hypr/default".source = config.lib.file.mkOutOfStoreSymlink "${dotsDir}/hypr/default";
        ".config/hypr/user".source = config.lib.file.mkOutOfStoreSymlink "${dotsDir}/hypr/user";
    };
}
