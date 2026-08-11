# modules/packages.nix

{ config, pkgs, lib, ... }:

{
    # To expose a single binary from a package without installing the whole thing,
    # use runCommand (for one binary) or linkFarm (for multiple):

    # (pkgs.runCommand "name" { } ''
    #     mkdir -p $out/bin
    #     ln -s ${pkgs.some-package}/bin/binary $out/bin/binary
    # '')

    # (pkgs.linkFarm "name" [
    #     { name = "bin/binary"; path = "${pkgs.some-package}/bin/binary"; }
    # ])
    environment.systemPackages = with pkgs; [
        # Basic utilities
        zsh wget curl

        # Python3 with some libraries
        (python3.withPackages (ps: with ps; [ jinja2 ]))
    ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Specific outdated package versions required by other packages
    nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
}
