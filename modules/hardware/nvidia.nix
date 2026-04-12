{config, pkgs, ... }:
{
 nixpkgs.config.allowUnfree = true;
 services.xserver.videoDrivers = [ "nvidia" ];
 hardware.graphics = {
   enable = true;
   enable32Bit = true;
 };
 hardware.nvidia = {
   modesetting.enable = true;
   powerManagement.enable = true;
   open = false;
   nvidiaSettings = true;
 };
}
