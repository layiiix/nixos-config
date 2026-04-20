{ config, pkgs, lib, ... }:
{
	programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true;
	  dedicatedServer.openFirewall = true;
	  localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [
          libkrb5
          keyutils
        ];
     };
	};
   	programs.gamemode.enable = true;
	hardware.graphics = {
	  enable32Bit = true;
	};
	environment.systemPackages = with pkgs; [
	  winetricks
	  wineWow64Packages.stable
	  protontricks
	  mangohud
	  protonup-ng
	  freetype
	  fontconfig
	  wine
      ffmpeg
	  wine64
	  vulkan-tools
      gamescope
	  cabextract # Indispensable para que winetricks pueda extraer e instalar fuentes de Windows
	];
	nixpkgs.config.allowUnfree = true;
  programs.obs-studio = {
    enable = true;
    # Forzar CUDA support para que obs_nvenc_h264_tex esté disponible
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
    plugins = with pkgs.obs-studio-plugins; [
      # Captura de pantalla en Wayland via PipeWire (nativo en OBS)
    ];
  };

}
