# home/quisiou/timers.nix


{ ... }:

{
    systemd.user.timers = {
        "vencord-autoupdate" = {
            Unit.Description = "Weekly Vencord update check";
            Timer.OnCalendar = "Monday *-*-* 09:00:00";
            Timer.Persistent = true;
            Install.WantedBy = [ "timers.target" ];
        };
    };
}
