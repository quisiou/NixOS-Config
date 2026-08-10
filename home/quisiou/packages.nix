# home/quisiou/packages.nix


{ config, pkgs, lib, ... }:

{
    home.packages = with pkgs; [
        # Basic terminal utilities
        file bat duf dust tree ffmpeg jq poppler fd ripgrep fzf zoxide resvg imagemagick
        _7zz-rar

        # More relevant terminal utils
        inotify-tools usbutils

        # Terminal (and tools)
        kitty starship fastfetch pokeget-rs

        # Python-related
        uv

        # Text editors
        neovim

        # Image editors and viewers
        gimp inkscape imv

        # Video viewer
        mpv

        # Other editors
        blender

        # Music
        musescore muse-sounds-manager
        spotify

        # Emulators
        pcsx2
        # rpcs3     # Still broken, wait a bit before adding it
        dolphin-emu
        ryubing

        # File managers
        (yazi.override { _7zz = _7zz-rar; })    # Yazi with RAR extraction support

        # System monitors
        btop brightnessctl

        # Desktop ecosystem
        hyprshot wl-clipboard cliphist
        awww eww quickshell
        wlopm
        pavucontrol

        # Language support and LSP
        clang-tools
        texlive.combined.scheme-medium
        (runCommand "qmlls" { } ''
            mkdir -p $out/bin
            ln -s ${qt6.qtdeclarative}/bin/qmlls $out/bin/qmlls
        '') # Qt's QML lsp

        # Other stuff
        bitwarden-desktop
        qbittorrent
    ];
}
