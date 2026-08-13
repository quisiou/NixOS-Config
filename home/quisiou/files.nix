# home/quisiou/files.nix

{ config, pkgs, lib, ... }:

{
    home.file = {
        # Quickshell
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

        # Scripts
        ".scripts/check_gow2018_hidraw.py".text = ''
            from pathlib import Path


            targetSection:  str     = '[System\\ControlSet001\\Services\\winebus]'
            targetOption:   str     = '"DisableHidraw"=dword:00000001'
            regPath:        Path    = Path.home() / ".steam" / "steam" / "steamapps" / "compatdata" / "1593500" / "pfx" / "system.reg"

            with open(regPath, "r", encoding="utf-8", errors="ignore") as f:
                lines = f.readlines()

            # Find the line where the target section starts
            sectionStart = None
            for _, line in enumerate(lines):
                if line.startswith(targetSection):
                    sectionStart = _
                    break

            if sectionStart is None:
                raise ValueError(f"Section {targetSection} not found in {regPath}")

            # Find the line where the target section ends
            sectionEnd = len(lines)
            for i in range(sectionStart + 1, len(lines)):
                stripped = lines[i].strip()
                if stripped == "" or stripped.startswith('['):
                    sectionEnd = i
                    break

            # If the target option is not present on the target section, insert it at the end of said section
            if not any(
                lines[i].strip().startswith(targetOption.split('=', 1)[0].strip())
                for i in range(sectionStart + 1, sectionEnd)
            ):
                lines.insert(sectionEnd, targetOption + '\n')
                with open(regPath, "w", encoding="utf-8") as f: # Only write to file if insertion was made; no need otherwise
                    f.writelines(lines)
        '';
        ".scripts/rl_replay_wrapper.sh" = {
            executable = true;
            text = ''
                #!/usr/bin/env sh
                set -e

                echo "$(date): wrapper invoked with args: $@" >> "$HOME/.scripts/wrapper.log"

                mkdir -p "$HOME/Videos/Clips"

                systemctl --user start gsr-replay@30.service
                echo "$(date): requested recorder start via systemctl" >> "$HOME/.scripts/wrapper.log"

                "$@"
                game_exit=$?

                systemctl --user stop gsr-replay@30.service 2>/dev/null || true

                exit "$game_exit"
            '';
        };

        # RPCS3
        "AppFiles/RPCS3/config.yml".text = ''
            Audio:
                Renderer: "Cubeb"
            Core:
                PPU Decoder: "Recompiler (LLVM)"
                SPU Decoder: "Recompiler (LLVM)"
                Preferred SPU Threads: 0
                SPU Cache: true
                SPU loop detection: true
            Video:
                Anisotropic Filter Override: 16
                Frame limit: "Off"
                Multithreaded RSX: true
                Renderer: "Vulkan"
                VSync Mode: "Disabled"
                Vulkan:
                    Adapter: "NVIDIA GeForce RTX 5060 Laptop GPU"
                Resolution: "1920x1080"
                Resolution Scale: 200
                Write Color Buffers: false
        '';
        "AppFiles/RPCS3/pad_config.yml".text = ''
            Player 1 Input:
                Handler: SDL
                Device: DualSense Wireless Controller 1
                Config:
                    Left Stick Left: LS X-
                    Left Stick Down: LS Y-
                    Left Stick Right: LS X+
                    Left Stick Up: LS Y+
                    Right Stick Left: RS X-
                    Right Stick Down: RS Y-
                    Right Stick Right: RS X+
                    Right Stick Up: RS Y+
                    Start: Start
                    Select: Back
                    PS Button: "Back&Start,Guide"
                    Square: West
                    Cross: South
                    Circle: East
                    Triangle: North
                    Left: Left
                    Down: Down
                    Right: Right
                    Up: Up
                    R1: RB
                    R2: RT
                    R3: RS
                    L1: LB
                    L2: LT
                    L3: LS
                    IR Nose: ""
                    IR Tail: ""
                    IR Left: ""
                    IR Right: ""
                    Tilt Left: ""
                    Tilt Right: ""
                    Motion Sensor X:
                        Axis: ""
                        Mirrored: false
                        Shift: 0
                    Motion Sensor Y:
                        Axis: ""
                        Mirrored: false
                        Shift: 0
                    Motion Sensor Z:
                        Axis: ""
                        Mirrored: false
                        Shift: 0
                    Motion Sensor G:
                        Axis: ""
                        Mirrored: false
                        Shift: 0
                    Orientation Reset Button: ""
                    Orientation Enabled: false
                    Pressure Intensity Button: ""
                    Pressure Intensity Percent: 50
                    Pressure Intensity Toggle Mode: false
                    Pressure Intensity Deadzone: 0
                    Analog Limiter Button: ""
                    Analog Limiter Toggle Mode: false
                    Left Stick Multiplier: 100
                    Right Stick Multiplier: 100
                    Left Stick Deadzone: 8000
                    Right Stick Deadzone: 8000
                    Left Stick Anti-Deadzone: 4259
                    Right Stick Anti-Deadzone: 4259
                    Left Trigger Threshold: 0
                    Right Trigger Threshold: 0
                    Left Pad Squircling Factor: 4000
                    Right Pad Squircling Factor: 4000
                    Color Value R: 0
                    Color Value G: 0
                    Color Value B: 20
                    Blink LED when battery is below 20%: true
                    Use LED as a battery indicator: false
                    LED battery indicator brightness: 10
                    Player LED enabled: true
                    Large Vibration Motor Multiplier: 100
                    Small Vibration Motor Multiplier: 100
                    Switch Vibration Motors: false
                    Vibration Threshold: 63
                    Mouse Movement Mode: Relative
                    Mouse Deadzone X Axis: 60
                    Mouse Deadzone Y Axis: 60
                    Mouse Acceleration X Axis: 200
                    Mouse Acceleration Y Axis: 250
                    Left Stick Lerp Factor: 100
                    Right Stick Lerp Factor: 100
                    Analog Button Lerp Factor: 100
                    Trigger Lerp Factor: 100
                    Device Class Type: 0
                    Vendor ID: 1356
                    Product ID: 616
                Buddy Device: ""
        '';
    };
}
