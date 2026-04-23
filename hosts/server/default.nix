{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common/base.nix
      ../../modules/hardware/nvidia.nix
      ../../modules/docker-media.nix
    ];

  networking.hostName = "server";
  networking.networkmanager.enable = true;

  # Habilitar KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Ajustes de firewall para Docker y Traefik (puertos HTTP, HTTPS, panel Traefik)
  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

  # Usuario
  users.users.layiiesp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "storage" "docker" ];
    packages = with pkgs; [
      tree
    ];
  };

  system.stateVersion = "25.11";
}
