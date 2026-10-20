# home/quisiou/dotfiles.nix


{ inputs, pkgs, ... }:

{
    programs.dotfiles = {
        enable = true;
        allEnabled = false;

        modules = {
            hypr = {
                enable = true;
                extraEnv = ''
                    hl.env("TZDIR", "/etc/zoneinfo")
                '';
                extraKeybinds = ''
                    hl.bind(
                        "ALT + F8",
                        hl.dsp.exec_cmd("systemctl --user kill -s SIGUSR1 --kill-whom=main 'gsr-replay@*.service'")
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
                extraLookAndFeel = ''
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
                extraWindowRules = ''
                    hl.window_rule({
                        match = { class = "^(mpv)$" },
                        float = true
                    })

                    hl.window_rule({
                        match = { class = "^(imv)$" },
                        float = true
                    })

                    hl.window_rule({
                        match = { class = "^(Tk)$" },
                        float = true
                    })
                '';
                plugins = [
                    inputs.hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking
                ];
            };
            kitty = {
                enable = true;
            };
            yazi = {
                enable = true;
                extraKeymaps = ''
                    [[mgr.prepend_keymap]]
                    on   = [ "g", "D" ]
                    run  = "cd ~/Downloads"
                    desc = "Go to ~/Downloads"

                    [[mgr.prepend_keymap]]
                    on   = [ "g", "d" ]
                    run  = "cd ~/Dotfiles"
                    desc = "Go to Dotfiles"

                    [[mgr.prepend_keymap]]
                    on   = [ "g", "n" ]
                    run  = "cd ~/NixOS-Config"
                    desc = "Go to NixOS Configuration"
                '';
            };
        };
    };
}
