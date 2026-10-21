# home/quisiou/dotfiles.nix


{ inputs, pkgs, config, ... }:

{
    programs.dotfiles = {
        enable = true;
        allEnabled = false;

        modules = {
            fastfetch = {
                enable = true;
            };
            hypr = {
                enable = true;
                package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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
                            },
                            dynamic_cursors = {
                                enabled = true,

                                -- tilt    - tilt the cursor based on x-velocity
                                -- rotate  - rotate the cursor based on movement direction
                                -- stretch - stretch the cursor shape based on direction and velocity
                                -- none    - do not change the cursor's behaviour
                                mode = "rotate",

                                -- minimum angle difference in degrees after which the shape is changed
                                -- smaller values are smoother, but more expensive for hw cursors
                                threshold = 2,

                                rotate = {

                                    -- length in px of the simulated stick used to rotate the cursor
                                    -- most realistic if this is your actual cursor size
                                    length = 20,

                                    -- clockwise offset applied to the angle in degrees
                                    -- this will apply to ALL shapes
                                    offset = 0.0,
                                },

                                tilt = {

                                    -- controls how powerful the tilt is, the lower, the more power
                                    -- this value controls at which speed (px/s) the full tilt is reached
                                    limit = 5000,

                                    -- relationship between speed and tilt, supports these values:
                                    -- linear             - a linear function is used
                                    -- quadratic          - a quadratic function is used (most realistic to actual air drag)
                                    -- negative_quadratic - negative version of the quadratic one, feels more aggressive
                                    -- see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
                                    activation = "negative_quadratic",

                                    -- time window (ms) over which the speed is calculated
                                    -- higher values will make slow motions smoother but more delayed
                                    window = 100,

                                    -- full tilt for each side (°)
                                    full = 60,
                                },

                                stretch = {

                                    -- controls how much the cursor is stretched
                                    -- this value controls at which speed (px/s) the full stretch is reached
                                    -- the full stretch being twice the original length
                                    limit = 3000,

                                    -- relationship between speed and stretch amount, supports these values:
                                    -- linear             - a linear function is used
                                    -- quadratic          - a quadratic function is used
                                    -- negative_quadratic - negative version of the quadratic one, feels more aggressive
                                    -- see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
                                    activation = "quadratic",

                                    -- time window (ms) over which the speed is calculated
                                    -- higher values will make slow motions smoother but more delayed
                                    window = 100,
                                },

                                shake = {
                                    enabled = true,

                                    -- controls how soon a shake is detected
                                    -- lower values mean sooner
                                    threshold = 6.0,

                                    -- magnification level immediately after shake start
                                    base = 4.0,
                                    -- magnification increase per second when continuing to shake
                                    speed = 4.0,
                                    -- how much the speed is influenced by the current shake intensity
                                    influence = 0.0,

                                    -- maximal magnification the cursor can reach
                                    -- values below 1 disable the limit (e.g. 0)
                                    limit = 0.0,

                                    -- time in milliseconds the cursor will stay magnified after a shake has ended
                                    timeout = 2000,

                                    -- show cursor behaviour `tilt`, `rotate`, etc. while shaking
                                    effects = true,

                                    -- enable ipc events for shake
                                    ipc = false,
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
                    inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
                ];
            };
            kitty = {
                enable = true;
            };
            nvim = {
                enable = true;
                lockfile = "${config.home.homeDirectory}/Dotfiles/nvim/lazy-lock.json";
                extraPackages = [
                    (pkgs.python3.withPackages (ps: with ps; [ jupytext pylatexenc ]))
                ];
            };
            starship = {
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
            zsh = {
                enable = true;
                linkRcFiles = false;
                extraAlias = ''
                    alias nrs="sudo nixos-rebuild switch    --flake /etc/nixos#chirimbolo"
                    alias nrb="sudo nixos-rebuild dry-build --flake /etc/nixos#chirimbolo"
                    alias uvinit="uv init && uv venv --seed && uv add ipykernel jupyter"
                    alias man="batman"
                '';
            };
        };
    };
}
