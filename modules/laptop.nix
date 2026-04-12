# modules/laptop.nix
{ config, pkgs, ... }:

{
  # ===== GESTIÓN DE ENERGÍA (TLP) =====
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  # ===== DESACTIVAR POWER-PROFILES-DAEMON =====
  services.power-profiles-daemon.enable = false;

  # ===== TOUCHPAD =====
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };
  };

  # ===== BRILLO DE PANTALLA =====
  programs.light.enable = true;

  # ===== WIFI (ahorro de energía) =====
  networking.networkmanager.wifi.powersave = true;

  # ===== BLUETOOTH =====
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ===== SUSPENSIÓN AL CERRAR TAPA =====
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  # ===== PAQUETES ESPECÍFICOS DE PORTÁTIL =====
  environment.systemPackages = with pkgs; [
    brightnessctl
    powertop
  ];
}
