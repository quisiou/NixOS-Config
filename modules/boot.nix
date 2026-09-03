# modules/boot.nix


{ config, pkgs, inputs, ... }:


let
    bootOptionsCount = 3;
    splashText = "I am Root!";
    backgroundImg = "";

    minegrubTheme = pkgs.stdenv.mkDerivation {
        name = "minegrub-theme";
        src = inputs.minegrub-theme;
        buildInputs = with pkgs; [ fastfetch (python3.withPackages (p: [ p.pillow ])) ];
        patchPhase = ''
            sed -i '$d' minegrub/update_theme.py
            top_value=$((170 + (${toString bootOptionsCount} - 2) * 72))
            sed -i '/^+ image {/,/^}$/s/top = 40%+[0-9]\+/top = 40%+'"$top_value"'/' minegrub/theme.txt
        '';
        buildPhase = ''
            python minegrub/update_theme.py "${backgroundImg}" "${splashText}"
        '';
        installPhase = ''
            cd minegrub
            mkdir -p $out/grub/themes/minegrub
            cp *.png $out/grub/themes/minegrub
            cp *.pf2 $out/grub/themes/minegrub
            cp theme.txt $out/grub/themes/minegrub
        '';
    };
in
{
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                efiSupport = true;
                device = "nodev"; # EFI-only, no MBR write
                useOSProber = false; # true if dual-boot another OS
                configurationLimit = 5; # keep last N generations

                minegrub-world-sel = {
                    enable = true;
                    customIcons = with config.system; [
                        {
                            inherit name;
                            lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
                            lineBottom = "Survival Mode, No Cheats, Version: " + nixos.release;
                            imgName = "nixos";
                        }
                    ];
                };

                extraConfig = ''
                    if [ -z "$chosen" ] ; then
                        if [ "''${config_file}" ] ; then
                            configfile $prefix/$config_file
                        fi
                    fi
                '';

                # Split the generated grub.cfg into "current entries" and "old generations",
                # and make grub load mainmenu.cfg first, declaratively.
                extraInstallCommands = ''
                    GRUB_DIR="/boot/grub"

                    ${pkgs.coreutils}/bin/install -Dm644 ${./grub/mainmenu.cfg} "$GRUB_DIR/mainmenu.cfg"

                    # --- theme placement ---
                    ${pkgs.coreutils}/bin/mkdir -p "$GRUB_DIR/themes/minegrub"
                    ${pkgs.coreutils}/bin/cp -a ${minegrubTheme}/grub/themes/minegrub/. "$GRUB_DIR/themes/minegrub/"

                    SCALED_BG="${inputs.minegrub-world-sel-theme}/assets/background-scaled/background-2560x1600.png"
                    if [ -f "$SCALED_BG" ]; then
                        ${pkgs.coreutils}/bin/cp -f "$SCALED_BG" "/boot/theme/background.png"
                    fi

                    CFG="$GRUB_DIR/grub.cfg"

                    if [ -f "$CFG" ]; then
                        # --- split grub.cfg into worlds.cfg / generations.cfg ---
                        ${pkgs.gawk}/bin/awk -v world="$GRUB_DIR/.worlds.tmp" -v inner="$GRUB_DIR/.gen-inner.tmp" '
                        BEGIN { insub = 0; depth = 0 }
                        /^submenu ".*- All configurations"/ { insub = 1; depth = 0 }
                        {
                            if (insub) {
                                o = gsub(/{/, "{")
                                c = gsub(/}/, "}")
                                depth += o - c
                                print > inner
                                if (depth == 0) { insub = 0 }
                                next
                            }
                            print > world
                        }
                        ' "$CFG"

                        if [ -s "$GRUB_DIR/.worlds.tmp" ]; then
                            ${pkgs.coreutils}/bin/mv -f "$GRUB_DIR/.worlds.tmp" "$GRUB_DIR/worlds.cfg"
                        fi

                        if [ -s "$GRUB_DIR/.gen-inner.tmp" ]; then
                            ${pkgs.gnused}/bin/sed -n '/^\(menuentry\|submenu\)/q;p' "$CFG" > "$GRUB_DIR/.gen-header.tmp"
                            total=$(${pkgs.coreutils}/bin/wc -l < "$GRUB_DIR/.gen-inner.tmp")
                            ${pkgs.coreutils}/bin/tail -n +2 "$GRUB_DIR/.gen-inner.tmp" | ${pkgs.coreutils}/bin/head -n $((total - 2)) > "$GRUB_DIR/.gen-body.tmp"
                            ${pkgs.coreutils}/bin/cat "$GRUB_DIR/.gen-header.tmp" "$GRUB_DIR/.gen-body.tmp" > "$GRUB_DIR/generations.cfg"

                            # --- rename "NixOS - Configuration NNN (date - version)" -> "Gen.NNN (datetime)" ---
                            pat='^menuentry "[^"]*- Configuration ([0-9]+) \('
                            : > "$GRUB_DIR/.gen-renamed.tmp"
                            while IFS= read -r line; do
                                if [[ "$line" =~ $pat ]]; then
                                    n="''${BASH_REMATCH[1]}"
                                    link="/nix/var/nix/profiles/system-$n-link"
                                    if [ -e "$link" ]; then
                                        ts=$(${pkgs.coreutils}/bin/date -d "@$(${pkgs.coreutils}/bin/stat -c %Y "$link")" '+%Y-%m-%d %H:%M')
                                    else
                                        ts="unknown"
                                    fi
                                    line=$(${pkgs.gnused}/bin/sed -E "s/\"[^\"]*- Configuration [0-9]+ \([^)]*\)\"/\"Gen.$n ($ts)\"/" <<< "$line")
                                fi
                                printf '%s\n' "$line" >> "$GRUB_DIR/.gen-renamed.tmp"
                            done < "$GRUB_DIR/generations.cfg"
                            ${pkgs.coreutils}/bin/mv -f "$GRUB_DIR/.gen-renamed.tmp" "$GRUB_DIR/generations.cfg"
                        fi

                        ${pkgs.coreutils}/bin/rm -f "$GRUB_DIR"/.gen-*.tmp "$GRUB_DIR"/.worlds.tmp

                        ${pkgs.grub2}/bin/grub-editenv "$GRUB_DIR/grubenv" set config_file=mainmenu.cfg
                    fi
                '';
            };
        };

        # Use latest kernel.
        kernelPackages = pkgs.linuxPackages_latest;

        kernel.sysctl = { "kernel.printk" = "3 4 1 3"; };
        kernelParams = [ "loglevel=3" ];
        kernelModules = [
            "hid_playstation"
        ];
    };
}
