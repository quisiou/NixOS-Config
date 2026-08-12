# home/quisiou/services.nix


{ config, pkgs, lib, ... }:

{
    services.ssh-agent.enable = true;

    systemd.user.services = {
        "dotfiles-clone" = {
            Unit = {
                Description = "Clone dotfiles repository from github";
                ConditionPathExists = "!${config.home.homeDirectory}/Dotfiles/.git";
                After = [ "network-online.target" ];
                Wants = [ "network-online.target" ];
            };
            Service = {
                Type = "oneshot";
                ExecStart = pkgs.writeShellScript "dotfiles-setup" ''
                    set -e

                    # Ensure the directory exists (Home Manager might have created subfolders already)
                    mkdir -p ${config.home.homeDirectory}/Dotfiles
                    cd ${config.home.homeDirectory}/Dotfiles

                    # Initialize Git in-place
                    ${pkgs.git}/bin/git init
                    ${pkgs.git}/bin/git remote add origin https://github.com/quisiou/Dotfiles.git

                    # Fetch remote refs
                    ${pkgs.git}/bin/git fetch origin

                    # Track the main branch without overwriting pre-existing untracked files
                    ${pkgs.git}/bin/git checkout -b main origin/main || ${pkgs.git}/bin/git checkout main
                '';
                ExecStartPost = "${pkgs.systemd}/bin/systemctl --user start dotfiles-setup.service";
                StandardOutput = "journal+console";
                StandardError = "journal+console";
            };
            Install.WantedBy = [ "default.target" ];
        };

        "dotfiles-setup" = {
            Unit = {
                Description = "Set up dotfiles";
            };
            Service = {
                Type = "oneshot";
                ExecStart = pkgs.writeShellScript "dotfiles-setup" ''
                    if [ ! -d "${config.home.homeDirectory}/Dotfiles" ]; then
                        echo "Dotfiles directory not found, skipping..."
                        exit 0
                    fi

                    if [ ! -f "${config.home.homeDirectory}/Dotfiles/setup.sh" ]; then
                        echo "Setup script not found, skipping..."
                        exit 0
                    fi

                    echo "Running dotfiles setup..."
                    ${pkgs.nix}/bin/nix-shell -I nixpkgs=${pkgs.path} \
                        -p cmake glib pkg-config networkmanager alsa-lib ninja qt6.qtbase qt6.qtdeclarative spirv-tools \
                        --run "export PATH=\$PATH:/run/current-system/sw/bin && ${config.home.homeDirectory}/Dotfiles/setup.sh -f -n"
                '';
                StandardOutput = "journal+console";
                StandardError = "journal+console";
            };
        };

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
    };
}
