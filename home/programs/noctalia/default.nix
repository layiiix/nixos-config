{ config, pkgs, ... }:
{
  programs.noctalia = {
    enable = true;
    settings = {
      bar.main = {
        position = "top";
      };
      shell = {
        ui_scale = 1.25; # Aumentamos la escala para que no se vea tan pequeño
      };
      wallpaper = {
        default = {
          path = "/home/layiiesp/Pictures/Wallpapers/tokyo_night_owl.png";
        };
      };
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Tokyo-Night";
      };
    };
  }; 
}
