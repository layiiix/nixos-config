{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rmpc
  ];

  xdg.configFile."rmpc/config.ron".source = ./config.ron;
  xdg.configFile."rmpc/theme.ron".source = ./theme.ron;
}
