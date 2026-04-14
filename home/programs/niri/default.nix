{ config, pkgs, inputs, ... }:

let
  useOutOfStoreSymlinks = config.home.useOutOfStoreSymlinks or false;
  configPath =
    if useOutOfStoreSymlinks then
      "${config.home.homeDirectory}/nixos-config/home/programs/niri/config.kdl"
    else
      ./config.kdl;
in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    # Puedes quitar esto si ya lo tienes en otro sitio
    enable = true;

    package = pkgs.niri;

    settings.includes = [
      configPath
    ];
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
