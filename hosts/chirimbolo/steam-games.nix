# hosts/chirimbolo/steam-games.nix

{ pkgs, ... }:

{
    programs.steam.config = {
        enable = true;
        onSteamRunning = "close";
        apps = {
            "Geometry Dash" = {
                id = 322170;
                compatTool = pkgs.ge-proton9-24;
                launchOptions.env.WINEDLLOVERRIDES = "xinput1_4=n,b";
            };

            "Rocket League" = {
                id = 252950;
                compatTool = pkgs.ge-proton9-24;
                launchOptions = {
                    env = {
                        WINEDLLOVERRIDES = "winmm=n,b";
                        __NV_PRIME_RENDER_OFFLOAD = 1;
                        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    };
                    wrappers = [ "gamemoderun" ];
                    args = [ "-NoIPv6" ];
                };
            };

            "The Witcher 3" = {
                id = 292030;
                compatTool = pkgs.ge-proton10-28;
                launchOptions = {
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
            };

            "God of War" = {
                # To fix Dualsense not getting detected, add this to
                # ~/.steam/steam/steamapps/compatdata/1593500/pfx/system.reg:
                # [System\\ControlSet001\\Services\\winebus] 1767307594
                # "DisableHidraw"=dword:00000001
                id = 1593500;
                compatTool = pkgs.ge-proton10-28;
                launchOptions = {
                    env = {
                        __NV_PRIME_RENDER_OFFLOAD = 1;
                        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                        __VK_LAYER_NV_optimus = "NVIDIA_only";
                        PROTON_ENABLE_WAYLAND = 1;
                        PROTON_ENABLE_NGX_UPDATER = 1;
                    };
                    wrappers = [ "gamemoderun" ];
                };
            };
        };
    };
}
