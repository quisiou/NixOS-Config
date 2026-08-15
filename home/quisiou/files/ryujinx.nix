# home/quisiou/files/ryujinx.nix

{ config, pkgs, lib, ... }:

{
    home.file = {
        "AppFiles/Ryujinx/Config.json".text = ''
            {
                "graphics_backend": "Vulkan",
                "res_scale": 2,
                "max_anisotropy": 16,
                "anti_aliasing": "None",
                "enable_shader_cache": true,
                "backend_threading": "Auto",
                "memory_manager_mode": "HostMappedUnsafe",
                "enable_ptc": true,
                "enable_vsync": false,
                "aspect_ratio": "Fixed16x9",
                "preferred_gpu": "0x10DE_0x2D19",
                "scaling_filter": "Bilinear",
                "audio_backend": "SDL2"
            }
        '';
        
        ".scripts/configure_ryujinx.sh" = {
            executable = true;
            text = ''
                set -eu

                CUSTOM_CONFIG_JSON="$HOME/AppFiles/Ryujinx/Config.json"
                CONFIG_JSON="$HOME/.config/Ryujinx/Config.json"

                mkdir -p "$(dirname "$CONFIG_JSON")"
                if [ ! -f "$CONFIG_JSON" ]; then
                    cp --no-preserve=mode "$CUSTOM_CONFIG_JSON" "$CONFIG_JSON"
                else
                    jq -s '.[0] * .[1]' "$CONFIG_JSON" "$CUSTOM_CONFIG_JSON" > "$CONFIG_JSON.tmp"
                    mv "$CONFIG_JSON.tmp" "$CONFIG_JSON"
                fi

                jq --arg dir "$HOME/.config/Ryujinx/games" '.game_dirs = [$dir]' "$CONFIG_JSON" > "$CONFIG_JSON.tmp"
                mv "$CONFIG_JSON.tmp" "$CONFIG_JSON"
            '';
        };
    };
}