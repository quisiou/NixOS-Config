# home/quisiou/services.nix


{ config, pkgs, ... }:

{
    services.ssh-agent.enable = true;

    systemd.user.services = {
        "gsr-replay@" = {
            Unit = {
                Description = "GPU Screen Recorder instant replay buffer for rocket league (on-demand)";
                After = [ "graphical-session.target" ];
            };
            Service = {
                Type = "simple";
                ExecStart = ''
                ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
                    -w eDP-1 \
                    -a default_output -ac opus \
                    -q very_high -k av1_10bit -cr limited -f 120 -fm cfr \
                    -o "%h/Videos/Clips/" -c mp4 -r %i
                '';
            };
        };

        "vencord-autoupdate" = {
            Unit.Description = "Pull and rebuild custom Vencord fork";
            Service = {
                Type = "oneshot";
                WorkingDirectory = "${config.home.homeDirectory}/.local/share/Vencord";
                ExecStart = pkgs.writeShellScript "vencord-update" ''
                    set -e
                    ${pkgs.git}/bin/git pull --ff-only
                    ${pkgs.pnpm}/bin/pnpm install --frozen-lockfile
                    ${pkgs.pnpm}/bin/pnpm build
                '';
            };
        };

        "vesktop-overlay" = {
            Unit.Description = "Call status OSD for vesktop implemented with Quickshell";
            Service = {
                Environment = [ "QML_IMPORT_PATH=%h/.config/quickshell/.build/qml" ];
                ExecStart = "${pkgs.quickshell}/bin/quickshell -c vesktop-overlay";
                Restart = "no";
            };
        };
    };
}
