{ config, pkgs, ... }:

let
  check-xbox-battery = pkgs.writeShellScriptBin "check-xbox-battery" ''
    for device in $(${pkgs.upower}/bin/upower -e | ${pkgs.gnugrep}/bin/grep -i -E 'gaming_input|joystick|xone'); do
      percentage=$(${pkgs.upower}/bin/upower -i "$device" | ${pkgs.gawk}/bin/awk '/percentage:/ {print $2}' | ${pkgs.coreutils}/bin/tr -d '%')
      dev_name=$(${pkgs.coreutils}/bin/basename "$device")
      
      if [ -n "$percentage" ] && [ "$percentage" -eq "$percentage" ] 2>/dev/null; then
        if [ "$percentage" -le 20 ]; then
          if [ ! -f "/tmp/xbox_batt_warned_$dev_name" ]; then
            ${pkgs.libnotify}/bin/notify-send -u critical -a "Mando Xbox" -i input-gaming "Batería baja" "Al mando le queda un $percentage% de batería."
            touch "/tmp/xbox_batt_warned_$dev_name"
          fi
        else
          rm -f "/tmp/xbox_batt_warned_$dev_name"
        fi
      fi
    done
  '';
in
{
  systemd.user.services.xbox-battery-notifier = {
    Unit = {
      Description = "Notificar batería baja del mando de Xbox";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${check-xbox-battery}/bin/check-xbox-battery";
    };
  };

  systemd.user.timers.xbox-battery-notifier = {
    Unit = {
      Description = "Comprobar batería del mando cada 5 minutos";
    };
    Timer = {
      OnBootSec = "2m";
      OnUnitActiveSec = "5m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
