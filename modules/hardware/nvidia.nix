{config, pkgs, ... }:
{
 nixpkgs.config.allowUnfree = true;
 nixpkgs.config.cudaSupport = true;
 services.xserver.videoDrivers = [ "nvidia" ];
 hardware.graphics = {
   enable = true;
   enable32Bit = true;
   extraPackages = with pkgs; [
     nvidia-vaapi-driver   # Para NVENC en Wayland/OBS
     libva-vdpau-driver
     libvdpau-va-gl
     nv-codec-headers-12  # Headers NVENC para codificación de video por GPU
   ];
 };
 hardware.nvidia = {
   modesetting.enable = true;
   powerManagement.enable = true;
   open = false;
   nvidiaSettings = true;
 };
 boot.kernelModules = [ "nvidia_uvm" ];
}
