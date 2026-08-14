# home/quisiou/files/pcsx2.nix

{ config, pkgs, lib, ... }:

{
    home.file = {
        "AppFiles/PCSX2/config.ini".text = ''
            [UI]
            SettingsVersion = 1
            SetupWizardIncomplete = false
            Theme = darkfusionblue


            [MemoryCards]
            Slot1_Enable = true
            Slot1_Filename = Mcd001.ps2
            Slot2_Enable = true
            Slot2_Filename = Mcd002.ps2


            [Pad1]
            Type = DualShock2
            InvertL = 0
            InvertR = 0
            Deadzone = 0
            AxisScale = 1.33
            LargeMotorScale = 1
            SmallMotorScale = 1
            ButtonDeadzone = 0
            PressureModifier = 0.5
            Up = SDL-0/DPadUp
            Right = SDL-0/DPadRight
            Down = SDL-0/DPadDown
            Left = SDL-0/DPadLeft
            Triangle = SDL-0/FaceNorth
            Circle = SDL-0/FaceEast
            Cross = SDL-0/FaceSouth
            Square = SDL-0/FaceWest
            Select = SDL-0/Back
            Start = SDL-0/Start
            L1 = SDL-0/LeftShoulder
            L2 = SDL-0/+LeftTrigger
            R1 = SDL-0/RightShoulder
            R2 = SDL-0/+RightTrigger
            L3 = SDL-0/LeftStick
            R3 = SDL-0/RightStick
            Analog = SDL-0/Guide
            LUp = SDL-0/-LeftY
            LRight = SDL-0/+LeftX
            LDown = SDL-0/+LeftY
            LLeft = SDL-0/-LeftX
            RUp = SDL-0/-RightY
            RRight = SDL-0/+RightX
            RDown = SDL-0/+RightY
            RLeft = SDL-0/-RightX
            LargeMotor = SDL-0/LargeMotor
            SmallMotor = SDL-0/SmallMotor
        '';
        
        ".scripts/configure_pcsx2.sh" = {
            executable = true;
            text = ''
                set -eu

                CUSTOM_CONFIG_INI="$HOME/AppFiles/PCSX2/config.ini"
                CONFIG_INI="$HOME/.config/PCSX2/inis/PCSX2.ini"
                
                mkdir -p "$(dirname "$CONFIG_INI")"
                if [ ! -f "$CONFIG_INI" ]; then
                    cp --no-preserve=mode "$CUSTOM_CONFIG_INI" "$CONFIG_INI"
                else
                    crudini --merge "$CONFIG_INI" < "$CUSTOM_CONFIG_INI"
                fi

                crudini --set "$CONFIG_INI" GameList RecursivePaths "$HOME/.config/PCSX2/games"
            '';
        };
    };
}