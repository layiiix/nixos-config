# hosts/laptop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/base.nix
    ../../modules/laptop.nix
    ../../modules/fingerprint.nix  
  ];

  networking.hostName = "laptop";

  users.users.laylisp = {
    isNormalUser = true;
    description = "layiiesp";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "storage" ];
  };

  system.stateVersion = "25.11";
}
