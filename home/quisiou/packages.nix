# home/quisiou/packages.nix


{ pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        # Basic terminal utilities
        file duf dust tree ffmpeg fd ripgrep resvg imagemagick
        _7zz-rar
        jq yq-go crudini poppler
        psmisc xwayland-satellite
        pay-respects # thefuck

        # More relevant terminal utils
        inotify-tools usbutils
        gh-dash

        # Terminal (and tools)
        kitty starship fastfetch pokeget-rs

        # Python-related
        uv

        # Image editors and viewers
        gimp inkscape imv
        upscayl

        # Other editors
        blender

        # Music
        musescore muse-sounds-manager
        spotify

        # Emulators
        pcsx2
        rpcs3
        dolphin-emu
        ryubing

        # File managers
        (yazi.override { _7zz = _7zz-rar; })    # Yazi with RAR extraction support

        # System monitors
        btop brightnessctl

        # Desktop ecosystem
        hyprshot wl-clipboard cliphist wl-freeze
        awww eww quickshell
        wlopm
        playerctl
        pavucontrol
        libnotify
        cava

        # Language support and LSP
        gcc clang-tools
        tree-sitter
        lua-language-server vim-language-server nixd marksman bash-language-server shellcheck basedpyright ruff

        # Other stuff
        bitwarden-desktop
        qbittorrent
        heroic
        zulip
    ] ++ [
        inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zotero
    ];
}
