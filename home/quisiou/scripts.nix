# home/quisiou/scripts.nix


{ config, pkgs, lib, ... }:

let
    dotsDir = "${config.home.homeDirectory}/Dotfiles";
    setupMarker = "${dotsDir}/.setup_completed";
    gitExec     = "${pkgs.git}/bin/git";
in
{
    home.activation = {
        # Dotfiles management
        cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            (
                if [ ! -d "${dotsDir}/.git" ]; then
                    set -e

                    # Ensure the directory exists (Home Manager might have created subfolders already)
                    run mkdir -p "${dotsDir}"

                    # Initialize Git in-place
                    run "${gitExec}" -C "${dotsDir}" init
                    run "${gitExec}" -C "${dotsDir}" remote add origin https://github.com/quisiou/Dotfiles.git

                    # Fetch remote refs
                    run "${gitExec}" -C "${dotsDir}" fetch origin

                    # Track the main branch without overwriting pre-existing untracked files
                    run "${gitExec}" -C "${dotsDir}" checkout -b main origin/main || run "${gitExec}" -C "${dotsDir}" checkout main
                fi
            )
        '';
        setupDotfiles = lib.hm.dag.entryAfter [ "cloneDotfiles" ] ''
            (
                if [ ! -d "${dotsDir}" ]; then
                    echo "Dotfiles directory not found, skipping..."
                    exit 0
                fi

                if [ -f "${setupMarker}" ]; then
                    echo "Dotfiles already setup, skipping..."
                    exit 0
                fi

                if [ ! -f "${dotsDir}/setup.sh" ]; then
                    echo "Setup script not found, skipping..."
                    exit 0
                fi

                echo "Running dotfiles setup..."
                run ${pkgs.nix}/bin/nix-shell -I nixpkgs=${pkgs.path} \
                    -p cmake glib pkg-config networkmanager alsa-lib ninja qt6.qtbase qt6.qtdeclarative spirv-tools \
                    --run "export PATH=\$PATH:/run/current-system/sw/bin && ${dotsDir}/setup.sh -f -n"

                # Symlink hyprland's theme.lua so nixOS declarative hyprland way does not break
                HYPR_CONFIG_DIR="${config.home.homeDirectory}/.config/hypr"
                run mkdir -p "$HYPR_CONFIG_DIR"
                run ln -sf "${dotsDir}/hypr/theme.lua" "$HYPR_CONFIG_DIR/theme.lua"

                run touch "${setupMarker}"
            )
        '';

        # Emulator setup scripts
        "setupDolphinEmu" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
            TARGET_DIR="$APP_FILES_DIR/DolphinEmu"
            GAMES_DIR="$TARGET_DIR/games"
            CONFIG_DIR="${config.home.homeDirectory}/.config/dolphin-emu"
            CONFIG_GAMES_DIR="${config.home.homeDirectory}/.config/dolphin-emu/games"
            CRUDINI="${pkgs.crudini}/bin/crudini"

            $DRY_RUN_CMD echo "Creating games directory..."
            $DRY_RUN_CMD mkdir -p "$GAMES_DIR"

            # Ensure Dolphin directories exist
            $DRY_RUN_CMD mkdir -p "$CONFIG_DIR"
            $DRY_RUN_CMD echo "Linking games directory..."
            $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_GAMES_DIR")"
            if [ -d "$CONFIG_GAMES_DIR" ] && [ ! -L "$CONFIG_GAMES_DIR" ]; then
                $DRY_RUN_CMD rm -rf "$CONFIG_GAMES_DIR"
            fi
            $DRY_RUN_CMD ln -sfn "$GAMES_DIR" "$CONFIG_GAMES_DIR"
        '';
        "setupPCSX2" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            TARGET_DIR="${config.home.homeDirectory}/AppFiles/PCSX2"
            BIOS_DIR="$TARGET_DIR/bios"
            MEMCARDS_DIR="$TARGET_DIR/memcards"
            GAMES_DIR="$TARGET_DIR/games"
            COMPLETION_FILE="$TARGET_DIR/.download_completed"
            TAR_GZ_FILENAME="$TARGET_DIR/pcsx2-meta-files.tar.gz"
            CONFIG_BIOS_DIR="${config.home.homeDirectory}/.config/PCSX2/bios"
            CONFIG_MEMCARDS_DIR="${config.home.homeDirectory}/.config/PCSX2/memcards"
            CONFIG_GAMES_DIR="${config.home.homeDirectory}/.config/PCSX2/games"

            if [ ! -f "$COMPLETION_FILE" ]; then
                export PATH="${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"

                $DRY_RUN_CMD echo "Downloading PCSX2 meta files from Google Drive..."

                $DRY_RUN_CMD mkdir -p "$TARGET_DIR"
                $DRY_RUN_CMD mkdir -p "$BIOS_DIR"

                $DRY_RUN_CMD ${pkgs.nix}/bin/nix-shell -p python3Packages.gdown \
                    --run "gdown 'https://drive.google.com/uc?id=1th7MY7cNvm2pxHwY2q1hFcbLLOI878xN' -O '$TAR_GZ_FILENAME'" \
                    && tar -xzf "$TAR_GZ_FILENAME" -C "$BIOS_DIR" \
                    && rm "$TAR_GZ_FILENAME" \
                    && touch "$COMPLETION_FILE"
            fi

            if [ -f "$COMPLETION_FILE" ]; then
                $DRY_RUN_CMD echo "Linking bios directory..."
                $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_BIOS_DIR")"
                if [ -d "$CONFIG_BIOS_DIR" ] && [ ! -L "$CONFIG_BIOS_DIR" ]; then
                    $DRY_RUN_CMD rm -rf "$CONFIG_BIOS_DIR"
                fi
                $DRY_RUN_CMD ln -sfn "$BIOS_DIR" "$CONFIG_BIOS_DIR"
            fi

            $DRY_RUN_CMD echo "Creating and linking memory cards directory..."
            $DRY_RUN_CMD mkdir -p "$MEMCARDS_DIR"
            $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_MEMCARDS_DIR")"
            if [ -d "$CONFIG_MEMCARDS_DIR" ] && [ ! -L "$CONFIG_MEMCARDS_DIR" ]; then
                $DRY_RUN_CMD rm -rf "$CONFIG_MEMCARDS_DIR"
            fi
            $DRY_RUN_CMD ln -sfn "$MEMCARDS_DIR" "$CONFIG_MEMCARDS_DIR"

            $DRY_RUN_CMD echo "Creating and linking games directory..."
            $DRY_RUN_CMD mkdir -p "$GAMES_DIR"
            $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_GAMES_DIR")"
            if [ -d "$CONFIG_GAMES_DIR" ] && [ ! -L "$CONFIG_GAMES_DIR" ]; then
                $DRY_RUN_CMD rm -rf "$CONFIG_GAMES_DIR"
            fi
            $DRY_RUN_CMD ln -sfn "$GAMES_DIR" "$CONFIG_GAMES_DIR"

            # Create basic PCSX2 config structure
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/cache"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/cheats"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/covers"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/gamesettings"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/inputprofiles"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/logs"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/patches"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/resources"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/sstates"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/textures"
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/videos"
        '';
        "setupRPCS3" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
            TARGET_DIR="$APP_FILES_DIR/RPCS3"
            FIRMWARE_URL="http://dus01.ps3.update.playstation.net/update/ps3/image/us/2026_0318_a2b60b6ac1d2e49e230144345616927c/PS3UPDAT.PUP"
            COMPLETION_FILE="$TARGET_DIR/.download_completed"
            GAMES_DIR="$TARGET_DIR/games"
            SAVES_DIR="$TARGET_DIR/saves"
            CONFIG_GAMES_DIR="${config.home.homeDirectory}/.config/rpcs3/games"
            CONFIG_SAVES_DIR="${config.home.homeDirectory}/.config/rpcs3/dev_hdd0/home/00000001/savedata"

            if [ ! -f "$COMPLETION_FILE" ]; then
                $DRY_RUN_CMD mkdir -p "$TARGET_DIR"

                $DRY_RUN_CMD echo "Downloading PS3 firmware from Sony's official site..."
                $DRY_RUN_CMD ${pkgs.wget}/bin/wget -O "$TARGET_DIR/PS3UPDAT.PUP" "$FIRMWARE_URL" \
                    && $DRY_RUN_CMD touch "$COMPLETION_FILE"
            fi

            if [ -f "$COMPLETION_FILE" ]; then
                $DRY_RUN_CMD mkdir -p "$GAMES_DIR"
                $DRY_RUN_CMD echo "Linking games directory..."
                $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_GAMES_DIR")"
                if [ -d "$CONFIG_GAMES_DIR" ] && [ ! -L "$CONFIG_GAMES_DIR" ]; then
                    $DRY_RUN_CMD rm -rf "$CONFIG_GAMES_DIR"
                fi
                $DRY_RUN_CMD ln -sfn "$GAMES_DIR" "$CONFIG_GAMES_DIR"

                $DRY_RUN_CMD mkdir -p "$SAVES_DIR"
                $DRY_RUN_CMD echo "Linking saves directory..."
                $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_SAVES_DIR")"
                if [ -d "$CONFIG_SAVES_DIR" ] && [ ! -L "$CONFIG_SAVES_DIR" ]; then
                    $DRY_RUN_CMD rm -rf "$CONFIG_SAVES_DIR"
                fi
                $DRY_RUN_CMD ln -sfn "$SAVES_DIR" "$CONFIG_SAVES_DIR"
            fi
        '';
        "setupRyujinx" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
            TARGET_DIR="$APP_FILES_DIR/Ryujinx"
            COMPLETION_FILE="$TARGET_DIR/.download_completed"
            TAR_GZ_FILENAME="$TARGET_DIR/ryujinx-meta-files.tar.gz"
            CONFIG_KEYS_DIR="${config.home.homeDirectory}/.config/Ryujinx/system/"
            CONFIG_FIRMWARE_DIR="${config.home.homeDirectory}/.config/Ryujinx/bis/system/Contents/registered/"
            GAMES_DIR="$TARGET_DIR/games"
            MODS_DIR="$TARGET_DIR/mods"
            SAVES_DIR="$TARGET_DIR/saves"
            CONFIG_GAMES_DIR="${config.home.homeDirectory}/.config/Ryujinx/games"
            CONFIG_SAVES_DIR="${config.home.homeDirectory}/.config/Ryujinx/bis/user/save"
            CONFIG_MODS_DIR="${config.home.homeDirectory}/.config/Ryujinx/mods/contents"

            if [ ! -f "$COMPLETION_FILE" ]; then
                export PATH="${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"

                $DRY_RUN_CMD echo "Downloading Ryujinx meta files from Google Drive..."

                $DRY_RUN_CMD mkdir -p "$TARGET_DIR"

                $DRY_RUN_CMD ${pkgs.nix}/bin/nix-shell -p python3Packages.gdown \
                    --run "gdown 'https://drive.google.com/uc?id=1s6fLOsalUYLnsMQC8785-CqfVLqIWegr' -O '$TAR_GZ_FILENAME'" \
                    && tar -xzf "$TAR_GZ_FILENAME" -C "$TARGET_DIR" \
                    && rm "$TAR_GZ_FILENAME" \
                    && touch "$COMPLETION_FILE"
            fi

            if [ -f "$COMPLETION_FILE" ]; then
                $DRY_RUN_CMD echo "Linking keys..."
                $DRY_RUN_CMD mkdir -p "$CONFIG_KEYS_DIR"
                for key in "$TARGET_DIR"/keys/*; do
                    if [ -e "$key" ]; then
                        $DRY_RUN_CMD ln -sf "$key" "$CONFIG_KEYS_DIR"
                    fi
                done

                $DRY_RUN_CMD echo "Linking firmware..."
                $DRY_RUN_CMD mkdir -p "$CONFIG_FIRMWARE_DIR"
                for fw in "$TARGET_DIR"/firmware/*; do
                    if [ -e "$fw" ]; then
                        $DRY_RUN_CMD ln -sf "$fw" "$CONFIG_FIRMWARE_DIR"
                    fi
                done
            fi

            $DRY_RUN_CMD echo "Creating and linking games directory..."
            $DRY_RUN_CMD mkdir -p "$GAMES_DIR"
            $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_GAMES_DIR")"
            if [ -d "$CONFIG_GAMES_DIR" ] && [ ! -L "$CONFIG_GAMES_DIR" ]; then
                $DRY_RUN_CMD rm -rf "$CONFIG_GAMES_DIR"
            fi
            $DRY_RUN_CMD ln -sfn "$GAMES_DIR" "$CONFIG_GAMES_DIR"

            $DRY_RUN_CMD echo "Creating saves directory..."
            $DRY_RUN_CMD mkdir -p "$SAVES_DIR"
            $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_SAVES_DIR")"
            if [ -d "$CONFIG_SAVES_DIR" ] && [ ! -L "$CONFIG_SAVES_DIR" ]; then
                $DRY_RUN_CMD rm -rf "$CONFIG_SAVES_DIR"
            fi
            $DRY_RUN_CMD ln -sfn "$SAVES_DIR" "$CONFIG_SAVES_DIR"

            $DRY_RUN_CMD echo "Creating mods directory..."
            $DRY_RUN_CMD mkdir -p "$MODS_DIR"
            $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_MODS_DIR")"
            if [ -d "$CONFIG_MODS_DIR" ] && [ ! -L "$CONFIG_MODS_DIR" ]; then
                $DRY_RUN_CMD rm -rf "$CONFIG_MODS_DIR"
            fi
            $DRY_RUN_CMD ln -sfn "$MODS_DIR" "$CONFIG_MODS_DIR"
        '';

        # Vesktop settings
        "vesktopVencordDir" = lib.hm.dag.entryAfter ["writeBoundary"] ''
            STATE_FILE="$HOME/.config/vesktop/state.json"
            $DRY_RUN_CMD mkdir -p "$(dirname "$STATE_FILE")"
            VENCORD_DIR="$HOME/.local/share/Vencord/dist"
            if [ -e "$STATE_FILE" ]; then
                $DRY_RUN_CMD ${pkgs.jq}/bin/jq --arg dir "$VENCORD_DIR" '.vencordDir = $dir' \
                "$STATE_FILE" > "$STATE_FILE.tmp" && $DRY_RUN_CMD mv "$STATE_FILE.tmp" "$STATE_FILE"
            else
                $DRY_RUN_CMD echo "{\"vencordDir\": \"$VENCORD_DIR\"}" > "$STATE_FILE"
            fi
        '';
    };
}
