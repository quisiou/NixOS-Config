# home/quisiou/xdg-mime.nix


{ config, pkgs, lib, ... }:

{
    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "application/pdf"           = [ "firefox.desktop" ];
            "text/html"                 = [ "firefox.desktop" ];
            "x-scheme-handler/http"     = [ "firefox.desktop" ];
            "x-scheme-handler/https"    = [ "firefox.desktop" ];
            "image/png"                 = [ "imv.desktop" ];
            "image/jpeg"                = [ "imv.desktop" ];
            "video/mp4"                 = [ "mpv.desktop" ];
            "text/plain"                = [ "nvim.desktop" ];
            "text/script.python"        = [ "nvim.desktop" ];
            "text/x-python"             = [ "nvim.desktop" ];
            "inode/directory"           = [ "nvim.desktop" ];
        };
        associations.added = {
            "text/plain"                = [ "nvim.desktop" "codium.desktop" ];
            "text/script.python"        = [ "nvim.desktop" "codium.desktop" ];
            "text/x-python"             = [ "nvim.desktop" "codium.desktop" ];
        };
    };
}
