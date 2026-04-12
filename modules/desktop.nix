{config, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = "performance";
  environment.systemPackages = with pkgs; [
    discord
    kdePackages.kdenlive
    virtualbox
  ];
}
