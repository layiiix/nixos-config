{config, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = "schedutil";
  environment.systemPackages = with pkgs; [
    discord
    kdePackages.kdenlive
    virtualbox
    antigravity-fhs
  ];
}
