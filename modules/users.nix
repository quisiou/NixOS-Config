# modules/users.nix


{ pkgs, ... }:

{
    users.users."quisiou" = {
        isNormalUser = true;
        description = "quisiou";
        extraGroups = [
            "wheel"
            "networkmanager"
            "video"
            "audio"
            "gamemode"
            "input"
        ];
        shell = pkgs.zsh;
    };
}
