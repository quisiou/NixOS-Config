# home/quisiou/programs.nix


{ config, pkgs, ... }:

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

    schemaGraphql = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/octokit/graphql-schema/baf144f319c7705e822de9a26f05d12e1c7c9df4/schema.graphql";
        hash = "sha256-PGLQUm0TPO5TIhyJ3ptFWt4k23i5561W1kLEwVvOJlQ=";
    };

    gh-board = pkgs.rustPlatform.buildRustPackage {
        pname = "gh-board";
        version = "1.5.0";

        src = pkgs.fetchFromGitHub {
            owner = "uzimaru0000";
            repo = "gh-board";
            rev = "c134bead3e8360c0b43a4948f5bebcee4314ddbd";
            hash = "sha256-gYoNRBQiSAim3/PAo6DSAbDvlaWQnGDTZyXvfnu4Qsc=";
        };

        cargoHash = "sha256-zlX2ooybGYX1vnl9ajGZhN5nDQ/QyqmSH4uwXbD/cBk=";

        postPatch = ''
            cp ${schemaGraphql} schema.graphql
        '';
    };
in
{
    programs = {
        bat = {
            enable = true;
            config = {
                theme = "TwoDark";
                style = "numbers,changes";
            };
            extraPackages = with pkgs.bat-extras; [ batman batgrep ];
        };
        direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
        };
        eza = {     ## ls, but better
            enable = true;
            enableZshIntegration = true;  # sets up ls, ll, la, lt, lla aliases
            icons = "auto";
            git = true;
        };
        firefox = {
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
        fzf = {
            enable = true;
            enableZshIntegration = true;

            defaultCommand = "fd --type f --hidden --exclude .git";
            defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];

            # Ctrl + t
            fileWidget = {
                command = "fd --type f --hidden --exclude .git";
                options = [ "--preview 'bat --color=always --line-range :200 {}'" ];
            };

            # Alt + c
            changeDirWidget = {
                command = "fd --type d --hidden --exclude .git";
                options = [ "--preview 'eza --tree --level=2 --color=always {}'" ];
            };
        };
        gh = {
            enable = true;

            settings = {
                git_protocol = "ssh";
                prompt = "enabled";
                prefer_editor_prompt = "disabled";
                color_labels = "disabled";
                accessible_colors = "disabled";
                accessible_prompter = "disabled";
                spinner = "enabled";

                aliases = {
                    co = "pr checkout";
                };

            extensions = [ gh-board ];
            };
        };
        git = {
            enable = true;
            settings = {
                user = {
                    name = "quisiou";
                    email = "marco.casteleiro@gmail.com";
                };
                init.defaultBranch = "main";
            };
        };
        lazygit = {
            enable = true;
            enableZshIntegration = true;
            settings.git.autoFetch = false;
        };
        mpv = {
            enable = true;
            config.hwdec = "auto";
        };
        neovim = {
            enable = true;
            defaultEditor = true;

            viAlias = true;
            vimAlias = true;

            extraPackages = with pkgs; [
                (python3.withPackages (ps: with ps; [
                    jupytext
                    pylatexenc
                ]))
            ];

            initLua = ''
                require("options")
                require("keymaps")
                require("lazy-config")
            '';
        };
        starship = {
            enable = true;
            enableZshIntegration = true;
            configPath = "${config.home.homeDirectory}/Dotfiles/starship/starship.toml";
        };
        thunderbird = {
            enable = true;
            profiles."quisiou" = {
                isDefault = true;

                settings = {
                    "mail.spellcheck.inline" = true;
                    "mail.shell.checkDefaultClient" = false;
                    "spellchecker.dictionary" = "en-US,es-ES";
                };
            };
        };
        vesktop = {
            enable = true;
            vencord.settings = {
                autoUpdate = false;
                autoUpdateNotification = false;
                notifyAboutUpdates = true;
            };
        };
        vscodium = {
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
        zoxide = {
            enable = true;
            enableZshIntegration = true;
            options = [ "--cmd cd" ];
        };
        zsh = {
            enable = true;

            defaultKeymap = "emacs";

            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            autocd = true;

            shellAliases = {
                "nrs"       =   "sudo nixos-rebuild switch    --flake /etc/nixos#chirimbolo";
                "nrb"       =   "sudo nixos-rebuild dry-build --flake /etc/nixos#chirimbolo";
                "uvinit"    =   "uv init && uv venv --seed && uv add ipykernel jupyter";
                "man"       =   "batman";
            };

            historySubstringSearch = {
                enable = true;
                searchUpKey = [ "^[[A" "^[OA" ];
                searchDownKey = [ "^[[B" "^[OB" ];
            };
            history = {
                size = 12000;
                save = 10000;
                path = "${config.home.homeDirectory}/.zsh_history";
                ignoreDups = true;
                ignoreAllDups = true;   # remove older duplicate when a repeat is entered
                ignoreSpace = true;     # commands starting with a space aren't saved
                findNoDups = true;
                saveNoDups = true;      # don't write duplicates to the history file
                extended = true;
                share = true;
                expireDuplicatesFirst = true;
            };
            profileExtra = ''
                # Source profile config
                [ -f "$HOME/.config/zsh/profile.zsh" ] && . "$HOME/.config/zsh/profile.zsh"
            '';
            envExtra = ''
                # Source environment variables
                [ -f "$HOME/.config/zsh/env.zsh" ] && . "$HOME/.config/zsh/env.zsh"
            '';
            initContent = ''
                # Fix kitty allways prompting for close confirmation
                if test -n "$KITTY_INSTALLATION_DIR"; then
                    export KITTY_SHELL_INTEGRATION="enabled"
                    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
                    kitty-integration
                    unfunction kitty-integration
                fi

                # Source main config
                [ -f "$HOME/.config/zsh/main.zsh" ] && . "$HOME/.config/zsh/main.zsh"

                # The fuck
                eval "$(pay-respects zsh)"
            '';
        };
    };
}
