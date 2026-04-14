{ ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font = wezterm.font 'JetBrainsMono Nerd Font'
      config.font_size = 13.0
      config.window_background_opacity = 0.85

      return config
    '';
  };
}
