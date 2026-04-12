{ config, pkgs, ... }:
{
	programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true;
	  dedicatedServer.openFirewall = true;
	  localNetworkGameTransfers.openFirewall = true;
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
	  wine64
	  vulkan-tools
	
	];
	nixpkgs.config.allowUnfree = true;
}
