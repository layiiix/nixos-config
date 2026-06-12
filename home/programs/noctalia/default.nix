{ config, pkgs, ... }:
{
  programs.noctalia = {
    enable = true;
    settings = {
      bar.main = {
        position = "top";
      };
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Tokyo-Night";
      };
    };
  }; 
}
