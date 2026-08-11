# home/quisiou/scripts.nix

{ config, pkgs, lib, ... }:

{
    # Emulator setup scripts
    home.activation.setupRyujinx = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
        TARGET_DIR="$APP_FILES_DIR/Ryujinx"
        COMPLETION_FILE="$TARGET_DIR/.download_completed"
        TAR_GZ_FILENAME="$TARGET_DIR/ryujinx-meta-files.tar.gz"
        CONFIG_KEYS_DIR="${config.home.homeDirectory}/.config/Ryujinx/system/"
        CONFIG_FIRMWARE_DIR="${config.home.homeDirectory}/.config/Ryujinx/bis/system/Contents/registered/"
        GAMES_DIR="$TARGET_DIR/games"
        MODS_DIR="$TARGET_DIR/mods"
        SAVES_DIR="$TARGET_DIR/saves"
        CONFIG_FILE="${config.home.homeDirectory}/.config/Ryujinx/Config.json"
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

            $DRY_RUN_CMD echo "Creating games directory..."
            $DRY_RUN_CMD mkdir -p "$GAMES_DIR"
            if [ -f "$CONFIG_FILE" ]; then
                $DRY_RUN_CMD echo "Updating game_dirs in Ryujinx Config.json..."
                TMP_FILE=$(mktemp)
                ${pkgs.jq}/bin/jq --arg dir "$GAMES_DIR" '.game_dirs = [$dir]' "$CONFIG_FILE" > "$TMP_FILE" \
                    && mv "$TMP_FILE" "$CONFIG_FILE"
            fi

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
        fi
    '';
    home.activation.setupPCSX2 = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
        TARGET_DIR="$APP_FILES_DIR/PCSX2"
        BIOS_DIR="$TARGET_DIR/bios"
        MEMCARDS_DIR="$TARGET_DIR/memcards"
        GAMES_DIR="$TARGET_DIR/games"
        COMPLETION_FILE="$TARGET_DIR/.download_completed"
        TAR_GZ_FILENAME="$TARGET_DIR/pcsx2-meta-files.tar.gz"
        CONFIG_BIOS_DIR="${config.home.homeDirectory}/.config/PCSX2/bios"
        CRUDINI="${pkgs.crudini}/bin/crudini"

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

        $DRY_RUN_CMD echo "Creating games directory..."
        $DRY_RUN_CMD mkdir -p "$GAMES_DIR"
        
        $DRY_RUN_CMD echo "Creating memory cards directory..."
        $DRY_RUN_CMD mkdir -p "$MEMCARDS_DIR"

        # Create basic PCSX2 config structure
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/cache"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/cheats"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/covers"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/gamesettings"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/inputprofiles"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/logs"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/memcards"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/patches"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/resources"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/sstates"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/textures"
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/PCSX2/videos"

        # PCSX2.ini file
        PCSX2_INI="${config.home.homeDirectory}/.config/PCSX2/inis/PCSX2.ini"
        $DRY_RUN_CMD mkdir -p "$(dirname "$PCSX2_INI")"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    UI          SettingsVersion         "1"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    UI          SetupWizardIncomplete   "false"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    UI          Theme                   "darkfusionblue"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Folders     MemoryCards             "$MEMCARDS_DIR"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    GameList    RecursivePaths          "$GAMES_DIR"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    MemoryCards Slot1_Enable            "true"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    MemoryCards Slot1_Filename          "RatchetClank1.ps2"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    MemoryCards Slot2_Enable            "true"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    MemoryCards Slot2_Filename          "RatchetClank2.ps2"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Type                    "DualShock2"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        InvertL                 "0"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        InvertR                 "0"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Deadzone                "0"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        AxisScale               "1.33"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        LargeMotorScale         "1"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        SmallMotorScale         "1"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        ButtonDeadzone          "0"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        PressureModifier        "0.5"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Up                      "SDL-0/DPadUp"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Right                   "SDL-0/DPadRight"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Down                    "SDL-0/DPadDown"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Left                    "SDL-0/DPadLeft"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Triangle                "SDL-0/FaceNorth"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Circle                  "SDL-0/FaceEast"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Cross                   "SDL-0/FaceSouth"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Square                  "SDL-0/FaceWest"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Select                  "SDL-0/Back"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Start                   "SDL-0/Start"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        L1                      "SDL-0/LeftShoulder"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        L2                      "SDL-0/+LeftTrigger"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        R1                      "SDL-0/RightShoulder"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        R2                      "SDL-0/+RightTrigger"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        L3                      "SDL-0/LeftStick"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        R3                      "SDL-0/RightStick"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        Analog                  "SDL-0/Guide"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        LUp                     "SDL-0/-LeftY"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        LRight                  "SDL-0/+LeftX"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        LDown                   "SDL-0/+LeftY"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        LLeft                   "SDL-0/-LeftX"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        RUp                     "SDL-0/-RightY"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        RRight                  "SDL-0/+RightX"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        RDown                   "SDL-0/+RightY"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        RLeft                   "SDL-0/-RightX"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        LargeMotor              "SDL-0/LargeMotor"
        $DRY_RUN_CMD $CRUDINI --set "$PCSX2_INI"    Pad1        SmallMotor              "SDL-0/SmallMotor"
    '';
    home.activation.setupDolphin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
        TARGET_DIR="$APP_FILES_DIR/Dolphin"
        GAMES_DIR="$TARGET_DIR/games"
        CONFIG_DIR="${config.home.homeDirectory}/.config/dolphin-emu"
        CRUDINI="${pkgs.crudini}/bin/crudini"

        $DRY_RUN_CMD echo "Creating games directory..."
        $DRY_RUN_CMD mkdir -p "$GAMES_DIR"
        
        # Ensure Dolphin directories exist
        $DRY_RUN_CMD mkdir -p "$CONFIG_DIR"

        # Dolphin.ini file
        DOLPHIN_INI="$CONFIG_DIR/Dolphin.ini"
        $DRY_RUN_CMD $CRUDINI --set "$DOLPHIN_INI"  General     ISOPath0    "$GAMES_DIR"
        $DRY_RUN_CMD $CRUDINI --set "$DOLPHIN_INI"  General     ISOPaths    1
        $DRY_RUN_CMD $CRUDINI --set "$DOLPHIN_INI"  Interface   ThemeName   "Clean Lite"
        $DRY_RUN_CMD $CRUDINI --set "$DOLPHIN_INI"  Settings    OSDFontSize 13
        $DRY_RUN_CMD $CRUDINI --set "$DOLPHIN_INI"  Core        GFXBackend  "Vulkan"

        # GFX.ini file
        GFX_INI="$CONFIG_DIR/GFX.ini"
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        ShowFPS                 "True"
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        ShowFTimes              "True"
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        ShowSpeed               "True"
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        InternalResolution      4
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        MSAA                    "0x00000008"
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        ShaderCompilationMode   1
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Settings        SSAA                    "False"
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Enhancements    PostProcessingShader    ""
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Enhancements    ForceTextureFiltering   0
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Enhancements    MaxAnisotropy           4
        $DRY_RUN_CMD $CRUDINI --set "$GFX_INI"  Hardware        Adapter                 1

        # QT.ini file
        QT_INI="$CONFIG_DIR/Qt.ini"
        $DRY_RUN_CMD $CRUDINI --set "$QT_INI"   userstyle   enabled     "false"
        $DRY_RUN_CMD $CRUDINI --set "$QT_INI"   userstyle   styletype   5

        # WiimoteNew.ini file
        WII_REMOTE_INI="$CONFIG_DIR/WiimoteNew.ini"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Device                      "SDL/0/DualSense Wireless Controller"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/A                   "\`Button S\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/B                   "\`Button E\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/1                   "\`Shoulder L\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/2                   "\`Shoulder R\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/-                   "Back"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/+                   "Start"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Buttons/Home                "Guide"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Shake/X                     "\`Button W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Shake/Y                     "\`Button W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Shake/Z                     "\`Button W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Extension                   "Nunchuk"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Stick/Calibration   "100.00 141.42 100.00 141.42 100.00 141.42 100.00 141.42"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Shake/X             "\`Button W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Shake/Y             "\`Button W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Shake/Z             "\`Button W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    D-Pad/Up                    "\`Pad N\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    D-Pad/Down                  "\`Pad S\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    D-Pad/Left                  "\`Pad W\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    D-Pad/Right                 "\`Pad E\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Buttons/C           "\`Trigger R\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Buttons/Z           "\`Trigger L\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Stick/Up            "\`Left Y+\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Stick/Down          "\`Left Y-\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Stick/Left          "\`Left X-\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    Nunchuk/Stick/Right         "\`Left X+\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IR/Up                       "\`Cursor Y-\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IR/Down                     "\`Cursor Y+\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IR/Left                     "\`Cursor X-\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IR/Right                    "\`Cursor X+\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 1 X    "\`IR Object 1 X\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 1 Y    "\`IR Object 1 Y\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 1 Size "\`IR Object 1 Size\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 2 X    "\`IR Object 2 X\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 2 Y    "\`IR Object 2 Y\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 2 Size "\`IR Object 2 Size\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 3 X    "\`IR Object 3 X\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 3 Y    "\`IR Object 3 Y\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 3 Size "\`IR Object 3 Size\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 4 X    "\`IR Object 4 X\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 4 Y    "\`IR Object 4 Y\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IRPassthrough/Object 4 Size "\`IR Object 4 Size\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUAccelerometer/Up         "\`Accel Up\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUAccelerometer/Down       "\`Accel Down\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUAccelerometer/Left       "\`Accel Left\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUAccelerometer/Right      "\`Accel Right\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUAccelerometer/Forward    "\`Accel Forward\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUAccelerometer/Backward   "\`Accel Backward\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUGyroscope/Pitch Up       "\`Gyro Pitch Up\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUGyroscope/Pitch Down     "\`Gyro Pitch Down\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUGyroscope/Roll Left      "\`Gyro Roll Left\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUGyroscope/Roll Right     "\`Gyro Roll Right\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUGyroscope/Yaw Left       "\`Gyro Yaw Left\`"
        $DRY_RUN_CMD $CRUDINI --set "$WII_REMOTE_INI"   Wiimote1    IMUGyroscope/Yaw Right      "\`Gyro Yaw Right\`"
    '';
}
