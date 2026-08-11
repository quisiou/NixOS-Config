# home/quisiou/programs.nix

{ config, pkgs, lib, ... }:

let
    mkFirefoxAddon = { name, addonId, url, hash }:
    pkgs.stdenv.mkDerivation {
        inherit name;
        src = pkgs.fetchurl { inherit url hash; };
        dontUnpack = true;
        installPhase = ''
            mkdir -p $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
            cp $src $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${addonId}.xpi
        '';
        passthru = { inherit addonId; };
        meta.description = name;
    };
in
{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            nrs = "sudo nixos-rebuild switch    --flake /etc/nixos#chirimbolo";
            nrb = "sudo nixos-rebuild dry-build --flake /etc/nixos#chirimbolo";
        };
        history = {
            size = 10000;
            save = 10000;
            ignoreDups = true;
            findNoDups = true;
            extended = true;
            share = true; # Share history between sessions
            # append = true;
        };
        profileExtra = ''
            # Source default profile config
            [ -f "$HOME/.config/zsh/default/profile.zsh" ] && . "$HOME/.config/zsh/default/profile.zsh"

            # Source user profile config
            [ -f "$HOME/.config/zsh/user/profile.zsh" ] && . "$HOME/.config/zsh/user/profile.zsh"
        '';
        envExtra = ''
            # Source default environment variables
            [ -f "$HOME/.config/zsh/default/env.zsh" ] && . "$HOME/.config/zsh/default/env.zsh"

            # Source personal environment variables
            [ -f "$HOME/.config/zsh/user/env.zsh" ] && . "$HOME/.config/zsh/user/env.zsh"
        '';
        initContent = ''
            # Fix kitty allways prompting for close confirmation
            if test -n "$KITTY_INSTALLATION_DIR"; then
                export KITTY_SHELL_INTEGRATION="enabled"
                autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
                kitty-integration
                unfunction kitty-integration
            fi

            # Source default main config
            [ -f "$HOME/.config/zsh/default/main.zsh" ] && . "$HOME/.config/zsh/default/main.zsh"

            # Source user main config
            [ -f "$HOME/.config/zsh/user/main.zsh" ] && . "$HOME/.config/zsh/user/main.zsh"
        '';
    };
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        configPath = "${config.home.homeDirectory}/Dotfiles/starship/starship.toml";
    };
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "QuiSioU";
                email = "marco.casteleiro@gmail.com";
            };
        };
    };
    programs.vesktop = {
        enable = true;
        vencord.settings = {
            autoUpdate = true;
            autoUpdateNotification = true;
            notifyAboutUpdates = true;
        };
    };
    programs.firefox = {
        enable = true;
        profiles."quisiou" = {
            settings."extensions.autoDisableScopes" = 0;
            extensions.packages = [
                (mkFirefoxAddon {
                    name = "vimium";
                    addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
                    url = "https://addons.mozilla.org/firefox/downloads/file/4717567/vimium_ff-2.4.2.xpi";
                    hash = "sha256-Ex4qZ1gOeukSWrGXgRWeYUCfrEe0Qfwngqq3Y5bq0ZY=";
                })
            ];
            bookmarks = {
                force = true;
                settings = [{
                    toolbar = true;
                    bookmarks = [
                        {
                            name = "NixOS";
                            bookmarks = [
                                {
                                    name = "Search";
                                    url = "https://search.nixos.org";
                                }
                                {
                                    name = "Home Manager";
                                    tags = [ "home" "manager" ];
                                    url = "https://nix-community.github.io/home-manager/options/home-manager/";
                                }
                            ];
                        }
                        "separator"
                        {
                            name = "GitHub";
                            url = "https://github.com";
                        }
                        "separator"
                        {
                            name = "Movies (torrent)";
                            url = "https://yts.gg/";
                        }
                    ];
                }];
            };
        };
    };
    programs.vscodium = {
        enable = true;

        profiles.default.extensions =
        (with pkgs.vscode-extensions; [
            llvm-vs-code-extensions.vscode-clangd
            twxs.cmake
            ms-toolsai.jupyter
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
            ms-toolsai.jupyter-keymap
            james-yu.latex-workshop
            sumneko.lua
            jnoortheen.nix-ide
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            ms-python.vscode-python-envs
            mechatroner.rainbow-csv
            tombi-toml.tombi
        ])
        ++
        (with pkgs.vscode-marketplace; [
            theqtcompany.qt-core
            theqtcompany.qt-qml
            eww-yuck.yuck
        ]);
    };
}
