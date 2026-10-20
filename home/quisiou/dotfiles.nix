# home/quisiou/dotfiles.nix


{ ... }:

{
    programs.dotfiles = {
        enable = true;
        allEnabled = false;

        modules = {
            kitty = {
                enable = true;
            };
            yazi = {
                enable = true;
                extraKeymaps = ''
                    [[mgr.prepend_keymap]]
                    on   = [ "g", "D" ]
                    run  = "cd ~/Downloads"
                    desc = "Go to ~/Downloads"

                    [[mgr.prepend_keymap]]
                    on   = [ "g", "d" ]
                    run  = "cd ~/Dotfiles"
                    desc = "Go to Dotfiles"

                    [[mgr.prepend_keymap]]
                    on   = [ "g", "n" ]
                    run  = "cd ~/NixOS-Config"
                    desc = "Go to NixOS Configuration"
                '';
            };
        };
    };
}
