# home/quisiou/files/dolphin-emu.nix

{ config, pkgs, lib, ... }:

{
    home.file = {
        "AppFiles/Dolphin/Dolphin.ini".text = ''
            [General]
            ISOPaths = 1
            [Interface]
            ThemeName = Clean Lite
            [Settings]
            OSDFontSize = 13
            [Core]
            GFXBackend = Vulkan
        '';

        "AppFiles/Dolphin/GFX.ini".text = ''
            [Settings]
            ShowFPS = True
            ShowFTimes = True
            ShowSpeed = True
            InternalResolution = 4
            MSAA = 0x00000008
            ShaderCompilationMode = 1
            SSAA = False
            [Enhancements]
            PostProcessingShader =
            ForceTextureFiltering = 0
            MaxAnisotropy = 4
            [Hardware]
            Adapter = 1
        '';

        "AppFiles/Dolphin/Qt.ini".text = ''
            [userstyle]
            enabled=false
            styletype=5
        '';

        "AppFiles/Dolphin/WiimoteNew.ini".text = ''
            [Wiimote1]
            Device = SDL/0/DualSense Wireless Controller
            Buttons/A = `Button S`
            Buttons/B = `Button E`
            Buttons/1 = `Shoulder L`
            Buttons/2 = `Shoulder R`
            Buttons/- = Back
            Buttons/+ = Start
            Buttons/Home = Guide
            Shake/X = `Button W`
            Shake/Y = `Button W`
            Shake/Z = `Button W`
            Extension = Nunchuk
            Nunchuk/Stick/Calibration = 100.00 141.42 100.00 141.42 100.00 141.42 100.00 141.42
            Nunchuk/Shake/X = `Button W`
            Nunchuk/Shake/Y = `Button W`
            Nunchuk/Shake/Z = `Button W`
            D-Pad/Up = `Pad N`
            D-Pad/Down = `Pad S`
            D-Pad/Left = `Pad W`
            D-Pad/Right = `Pad E`
            Nunchuk/Buttons/C = `Trigger R`
            Nunchuk/Buttons/Z = `Trigger L`
            Nunchuk/Stick/Up = `Left Y+`
            Nunchuk/Stick/Down = `Left Y-`
            Nunchuk/Stick/Left = `Left X-`
            Nunchuk/Stick/Right = `Left X+`
            IR/Up = `Cursor Y-`
            IR/Down = `Cursor Y+`
            IR/Left = `Cursor X-`
            IR/Right = `Cursor X+`
            IRPassthrough/Object 1 X = `IR Object 1 X`
            IRPassthrough/Object 1 Y = `IR Object 1 Y`
            IRPassthrough/Object 1 Size = `IR Object 1 Size`
            IRPassthrough/Object 2 X = `IR Object 2 X`
            IRPassthrough/Object 2 Y = `IR Object 2 Y`
            IRPassthrough/Object 2 Size = `IR Object 2 Size`
            IRPassthrough/Object 3 X = `IR Object 3 X`
            IRPassthrough/Object 3 Y = `IR Object 3 Y`
            IRPassthrough/Object 3 Size = `IR Object 3 Size`
            IRPassthrough/Object 4 X = `IR Object 4 X`
            IRPassthrough/Object 4 Y = `IR Object 4 Y`
            IRPassthrough/Object 4 Size = `IR Object 4 Size`
            IMUAccelerometer/Up = `Accel Up`
            IMUAccelerometer/Down = `Accel Down`
            IMUAccelerometer/Left = `Accel Left`
            IMUAccelerometer/Right = `Accel Right`
            IMUAccelerometer/Forward = `Accel Forward`
            IMUAccelerometer/Backward = `Accel Backward`
            IMUGyroscope/Pitch Up = `Gyro Pitch Up`
            IMUGyroscope/Pitch Down = `Gyro Pitch Down`
            IMUGyroscope/Roll Left = `Gyro Roll Left`
            IMUGyroscope/Roll Right = `Gyro Roll Right`
            IMUGyroscope/Yaw Left = `Gyro Yaw Left`
            IMUGyroscope/Yaw Right = `Gyro Yaw Right`
        '';
        
        ".scripts/configure_dolphin-emu.sh" = {
            executable = true;
            text = ''
                set -eu

                CUSTOM_DOLPHIN_INI="$HOME/AppFiles/Dolphin/Dolphin.ini"
                DOLPHIN_INI="$HOME/.config/dolphin-emu/Dolphin.ini"

                CUSTOM_GFX_INI="$HOME/AppFiles/Dolphin/GFX.ini"
                GFX_INI="$HOME/.config/dolphin-emu/GFX.ini"

                CUSTOM_QT_INI="$HOME/AppFiles/Dolphin/Qt.ini"
                QT_INI="$HOME/.config/dolphin-emu/Qt.ini"

                CUSTOM_WIIMOTE_INI="$HOME/AppFiles/Dolphin/WiimoteNew.ini"
                WIIMOTE_INI="$HOME/.config/dolphin-emu/WiimoteNew.ini"

                merge_config() {
                    local custom="$1"
                    local live="$2"

                    mkdir -p "$(dirname "$live")"
                    if [ ! -f "$live" ]; then
                        cp --no-preserve=mode "$custom" "$live"
                    else
                        crudini --merge "$live" < "$custom"
                    fi
                }

                merge_config "$CUSTOM_DOLPHIN_INI" "$DOLPHIN_INI"
                merge_config "$CUSTOM_GFX_INI" "$GFX_INI"
                merge_config "$CUSTOM_QT_INI" "$QT_INI"
                merge_config "$CUSTOM_WIIMOTE_INI" "$WIIMOTE_INI"
                
                crudini --set "$DOLPHIN_INI" General ISOPath0 "$HOME/.config/dolphin-emu/games"
            '';
        };
    };
}