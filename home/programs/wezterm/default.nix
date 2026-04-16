{ isLaptop, ... }:

let
  fontSize = if isLaptop then "11.0" else "13.0";
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font = wezterm.font 'JetBrainsMono Nerd Font'
      config.font_size = ${fontSize}
      config.window_background_opacity = 0.85

      return config
    '';
  };
}
