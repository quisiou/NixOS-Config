# modules/services.nix

{ config, pkgs, lib, ... }:

{
    services = {
        blueman.enable = true;
        avahi.enable = true;
        printing.enable = true;     # CUPS
        pipewire = {    # Sound
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
            wireplumber.enable = true;
        };
        usbguard = {
            enable = true;
            rules = ''
                # Mouse: Razer Viper V2 Pro
                allow id 1532:00a6

                # Keyboard: Razer Cynosa V2
                allow id 1532:025e

                # Internal wireless module
                allow id 13d3:3607

                # Dualsense Controller (PS5)
                allow id 054c:0ce6 name "DualSense Wireless Controller" hash "AqOd+Rhe+ykrZbcx4QELtxDKfLhjtlQZncBxJ0R+6BE=" with-interface { 01:01:00 01:02:00 01:02:00 01:02:00 01:02:00 03:00:00 } with-connect-type "hotplug"

                # Sandisk USB (128GB) back up storage
                allow id 0781:5591 serial "01010279e968296f36e73a3c6a187ccd7a135399bfc99ea8bf8a536505bf62899d0500000000000000000000d8db4c6f000e130091558107a3aeaec3" name " SanDisk 3.2Gen1" hash "3lD0uMcfYi2IsVdGiVFylnj1HucwsJnJPtn99lHnDIU=" with-interface 08:06:50 with-connect-type "hotplug"

                # Sandisk USB (128GB) personal usage
                allow id 0781:55a3 serial "00010003052425114903" name " SanDisk 3.2Gen1" hash "rX83M/x1NHaQs/3CtHLirrxJo9s64TJxWQPHtskwAMI=" with-interface { 08:06:50 08:06:62 } with-connect-type "hotplug"

                # Internal USB 2.0
                allow id 1d6b:0002

                # Internal USB 3.0
                allow id 1d6b:0003
            '';
        };
    };
}
