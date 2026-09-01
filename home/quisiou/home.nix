# home/quisiou/home.nix


{ ... }:

{
    imports = [
        ./packages.nix
        ./programs.nix
        ./scripts.nix
        ./services.nix
        ./themes.nix
        ./timers.nix
        ./variables.nix
        ./wayland.nix
        ./xdg-desktop.nix
        ./xdg-mime.nix

        # Nix-managed files
        ./files/dotfiles.nix
        ./files/dolphin-emu.nix
        ./files/pcsx2.nix
        ./files/rpcs3.nix
        ./files/ryujinx.nix
        ./files/steam.nix
    ];

    home = {
        username = "quisiou";
        homeDirectory = "/home/quisiou";
        stateVersion = "26.05";
    };

    programs.home-manager.enable = true;
}
