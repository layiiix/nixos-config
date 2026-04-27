{ config, pkgs, inputs, isLaptop, ... }:

{
  imports = [
   # inputs.niri.homeModules.config
    inputs.noctalia.homeModules.default
    ./programs/default.nix
  ];
# programs.niri = {
 #    settings = {
  # layout.gaps = 5;
  # binds = {
   #  "Mod+Return".action = { spawn = [ "wezterm" ]; };
    # "Mod+D".action = { spawn = [ "fuzzel" ]; };
   #  "Mod+Q".action = { close = {}; };
    # "Mod+Shift+E".action = { quit = {}; };
  # };
 #  spawn-at-startup = [
  #  { command = [ "noctalia-shell" ]; }
  # ];
 # };
# };


  services.udiskie = {
    enable = true;
    tray = "never"; # IMPORTANTE en Niri (no hay system tray)
  };


  home.packages = with pkgs; [
    wezterm
    fuzzel
    waybar
    git
    # Wayland Utils
    polkit_gnome
    pavucontrol
    # helium está en home/programs/helium/default.nix (con idioma español)
  ];
  home.stateVersion = "25.11";
}
