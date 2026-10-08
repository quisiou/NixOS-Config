# hosts/chirimbolo/steam-config.nix

{ pkgs, config, ... }:

{
    programs.steam.config = {
        enable = true;
        onSteamRunning = "close";
        desktopUiScale = 1.6;
        apps = {
            "322170" = {
                name = "Geometry Dash";
                compatTool = pkgs.ge-proton9-24;
                env.WINEDLLOVERRIDES = "xinput1_4=n,b";
            };

            "252950" = {
                name = "Rocket League";
                compatTool = pkgs.ge-proton9-24;
                env = {
                    WINEDLLOVERRIDES = "winmm=n,b";
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                };
                wrappers = [
                    "gamemoderun"
                    "${config.home-manager.users.quisiou.home.homeDirectory}/.scripts/rl_replay_wrapper.sh"
                ];
                args = [ "-NoIPv6" ];
            };

            "292030" = {
                name = "The Witcher 3";
                compatTool = pkgs.ge-proton11-7;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                    DXVK_ASYNC = 1;
                    PROTON_ENABLE_NGX_UPDATER = 1;
                };
                wrappers = [ "gamemoderun" ];
            };

            "1593500" = {
                # To fix Dualsense not getting detected, add this to
                # ~/.steam/steam/steamapps/compatdata/1593500/pfx/system.reg:
                # [System\\ControlSet001\\Services\\winebus] 1767307594
                # "DisableHidraw"=dword:00000001
                name = "God of War";
                compatTool = pkgs.ge-proton11-7;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                    PROTON_ENABLE_NGX_UPDATER = 1;
                };
                wrappers = [ "gamemoderun" ];
                # preHook = ''
                #     python3 "$HOME/.scripts/check_steam_game_hidraw.py" 1593500
                # '';
            };

            "631510" = {
                name = "Devil May Cry HD Collection";
                compatTool = pkgs.ge-proton10-17;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                };
                wrappers = [ "gamemoderun" ];
                # preHook = ''
                #     python3 "$HOME/.scripts/check_steam_game_hidraw.py" 631510
                # '';
            };

            "462780" = {
                name = "Darksiders Warmastered Edition";
                compatTool = pkgs.ge-proton11-7;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                };
                wrappers = [ "gamemoderun" ];
            };

            "388410" = {
                name = "Darksiders II Deathinitive Edition";
                compatTool = pkgs.ge-proton11-7;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                };
                wrappers = [ "gamemoderun" ];
            };

            "606280" = {
                name = "Darksiders III";
                compatTool = pkgs.ge-proton11-7;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                    PROTON_ENABLE_NGX_UPDATER = 1;  # DLSS support, worth having on the 5060
                };
                wrappers = [ "gamemoderun" ];
            };

            "710920" = {
                name = "Darksiders Genesis";
                compatTool = pkgs.ge-proton11-7;
                env = {
                    __NV_PRIME_RENDER_OFFLOAD = 1;
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    __VK_LAYER_NV_optimus = "NVIDIA_only";
                    PROTON_ENABLE_WAYLAND = 1;
                };
                wrappers = [ "gamemoderun" ];
            };
        };
    };
}
