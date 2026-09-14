# modules/virtualisation.nix


{ pkgs, ... }:

{
    virtualisation = {
        libvirtd = {
            enable = true;
            qemu = {
                package = pkgs.qemu_kvm;
                swtpm.enable = true;
                vhostUserPackages = [ pkgs.virtiofsd ];
            };
        };
        spiceUSBRedirection.enable = true;
    };
}
