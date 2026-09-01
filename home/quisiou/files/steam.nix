# home/quisiou/files/steam.nix


{ ... }:

{
    home.file = {
        ".scripts/rl_replay_wrapper.sh" = {
            executable = true;
            text = ''
                #!/usr/bin/env sh
                set -e

                mkdir -p "$HOME/Videos/Clips"

                systemctl --user start gsr-replay@30.service

                "$@"
                game_exit=$?

                systemctl --user stop gsr-replay@30.service 2>/dev/null || true

                exit "$game_exit"
            '';
        };

        ".scripts/check_steam_game_hidraw.py".text = ''
            import sys
            from pathlib import Path


            if len(sys.argv) != 2:
                sys.exit(f"Usage: {sys.argv[0]} <steam-app-id>")

            appId:          str     = sys.argv[1]
            targetSection:  str     = r'[System\\ControlSet001\\Services\\winebus]'
            targetOption:   str     = '"DisableHidraw"=dword:00000001'
            regPath:        Path    = Path.home() / ".steam" / "steam" / "steamapps" / "compatdata" / appId / "pfx" / "system.reg"

            if not regPath.exists():
                sys.exit(f"No prefix registry found at {regPath} — has the game been run at least once?")

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
    };
}
