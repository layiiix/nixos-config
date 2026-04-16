{ config, pkgs, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar.position = "top";
      colorSchemes = {
        darkMode = true;
        prredefinedScheme = "Tokyo Night";
      };
    };
  }; 
}
