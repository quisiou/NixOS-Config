# home/quisiou/xdg-desktop.nix


{ config, pkgs, lib, ... }:

let
    pcsx2Launcher = pkgs.writeShellScript "pcsx2-launcher" ''
        set -eu
        "${config.home.homeDirectory}/.scripts/setup_pcsx2_config.sh"
        exec ${pkgs.pcsx2}/bin/pcsx2-qt
    '';
    rpcs3Launcher = pkgs.writeShellScript "rpcs3-launcher" ''
        set -eu
        "${config.home.homeDirectory}/.scripts/setup_rpcs3_config.sh"
        exec ${pkgs.rpcs3}/bin/rpcs3 "$@"
    '';
in
{
    xdg.desktopEntries = {
        btop = {
            type = "Application";
            name = "btop++";
            genericName = "System Monitor";
            comment = "Resource monitor that shows usage and stats for processor, memory, disks, network and processes";
            icon = "btop";
            exec = "kitty -e btop";
            terminal = true;
            categories = [
                "System"
                "Monitor"
                "ConsoleOnly"
            ];
            settings = {
                Keywords = "system;process;task";
            };
        };
        firefox = {
            type = "Application";
            name = "Firefox";
            genericName = "Web Browser";
            comment = "Fast and private browser";
            icon = "firefox";
            exec = "firefox --name firefox %U";
            terminal = false;
            startupNotify = true;
            categories = [
                "Network"
                "WebBrowser"
            ];
            settings = {
                Keywords = "Internet;WWW;Browser;Web;Explorer";
            };
            actions = {
                "new-private-window" = {
                    name = "New Private Window";
                    exec = "firefox --private-window %U";
                };
                "new-window" = {
                    name = "New Window";
                    exec = "firefox --new-window %U";
                };
                "profile-manager-window" = {
                    name = "Profile Manager";
                    exec = "firefox --ProfileManager";
                };
            };
        };
        nvim = {
            type = "Application";
            name = "Neovim";
            genericName = "Text Editor";
            comment = "Edit text files";
            icon = "nvim";
            exec = "kitty -e nvim %F";
            terminal = true;
            startupNotify = false;
            categories = [
                "Utility"
                "TextEditor"
                "Development"
            ];
            settings = {
                Keywords = "Text;editor;vim;nvim";
            };
        };
        "org.musescore.MuseScore" = {
            type = "Application";
            name = "MuseScore Studio";
            genericName = "Music Notation";
            comment = "Create, play and print beautiful sheet music";
            icon = "mscore";
            exec = "env DESKTOPINTEGRATION=false QT_SCALE_FACTOR=1.5 QT_QPA_PLATFORM=wayland mscore %U";
            terminal = false;
            startupNotify = true;
            categories = [
                "AudioVideo"
                "Audio"
                "Graphics"
                "2DGraphics"
                "VectorGraphics"
                "RasterGraphics"
                "Publishing"
                "Midi"
                "Mixer"
                "Sequencer"
                "Music"
                "Qt"
            ];
            settings = {
                Keywords = "music;notation;composition;composing;arranging;making;sheet music;music notation software;lead sheet;leadsheet;score;full score;scorewriter;MIDI;musicxml;playback;instrument";
            };
        };
        mpv = {
            type = "Application";
            name = "MPV Media Player";
            genericName = "Multimedia player";
            comment = "Play movies and songs";
            icon = "mpv";
            exec = "mpv --player-operation-mode=pseudo-gui -- %U";
            terminal = false;
            startupNotify = false;
            categories = [
                "AudioVideo"
                "Audio"
                "Video"
                "Player"
                "TV"
            ];
            settings = {
                Keywords = "mpv;media;player;video;audio;tv";
            };
            noDisplay = true;
        };
        PCSX2 = {
            type = "Application";
            name = "PCSX2";
            genericName = "PlayStation 2 Emulator";
            comment = "Sony PlayStation 2 emulator";
            icon = "PCSX2";
            exec = "${pcsx2Launcher}";
            terminal = false;
            categories = [
                "Game"
                "Emulator"
            ];
            settings = {
                Keywords = "game;emulator";
                StartupWMClass = "PCSX2";
            };
        };
        rpcs3 = {
            type = "Application";
            name = "RPCS3";
            genericName = "PlayStation 3 Emulator";
            comment = "An open-source PlayStation 3 emulator/debugger written in C++.";
            icon = "rpcs3";
            exec = "${rpcs3Launcher} %f";
            terminal = false;
            categories = [
                "Game"
                "Emulator"
            ];
            settings = {
                Keywords = "PS3;Playstation";
                StartupWMClass = "rpcs3";
            };
        };
    };
}
