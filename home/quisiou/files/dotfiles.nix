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
        "Dotfiles/hypr/user/keybinds.lua".text = ''
            -- hypr/user/keybinds.lua


            ----- USER'S CUSTOM KEYBINDS CONFIGURATION --------------------------- #
            hl.bind(
                "ALT + F8",
                hl.dsp.exec_cmd("pkill -SIGUSR1 -f 'gpu-screen-recorder -w'")
            )

            hl.unbind(
                Config.mainMod .. " + L",
                hl.dsp.exec_cmd("qs -c shell ipc call controlMenu lockSession")
            )

            -- hyprtasking
            hl.bind(Config.mainMod .. " + Tab", function() hl.plugin.hyprtasking.toggle("cursor") end)

            -- escape closes the overview if it's open
            hl.bind("escape", function()
            if hl.plugin.hyprtasking.is_active() then
                hl.plugin.hyprtasking.toggle('all')
            end
            end, { non_consuming = true })

            hl.bind("SUPER + H", function() hl.plugin.hyprtasking.move("left") end)
            hl.bind("SUPER + J", function() hl.plugin.hyprtasking.move("down") end)
            hl.bind("SUPER + K", function() hl.plugin.hyprtasking.move("up") end)
            hl.bind("SUPER + L", function() hl.plugin.hyprtasking.move("right") end)

        '';
        "Dotfiles/hypr/user/look_and_feel.lua".text = ''
            -- hypr/user/look_and_feel.lua


            ----- USER'S CUSTOM LOOK AND FEEL CONFIGURATION --------------------------- #
            hl.config({
                plugin = {
                    hyprtasking = {
                        gap_size = 10,
                        border_size = 2,
                        bg_color = tonumber("ff" .. (theme.colors.BG_TINTED):sub(2), 16),
                        close_overview_on_reload = false,

                        gestures = {
                            enabled = true,
                            move_fingers = 3,
                            move_distance = 300,
                            open_fingers = 4,
                            open_distance = 300,
                            open_positive = true,
                        },

                        grid = {
                            rows = 3,
                            cols = 3,
                            layers = 2,
                            gaps_use_aspect_ratio = true,
                        },

                        linear = {
                            top = false,
                            height = 400,
                            scroll_speed = 1.0,
                            blur = false,
                        }
                    }
                }
            })

        '';
        "Dotfiles/hypr/user/windowrules.lua".text = ''
            -- hypr/user/windowrules.lua


            ----- USER'S CUSTOM WINDOW RULES CONFIGURATION --------------------------- #
            hl.window_rule({
                match = { class = "^(mpv)$" },
                float = true
            })

            hl.window_rule({
                match = { class = "^(imv)$" },
                float = true
            })
        '';
    };
}
