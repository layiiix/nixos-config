{config, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = "schedutil";
  environment.systemPackages = with pkgs; [
    vesktop
    kdePackages.kdenlive
    virtualbox
    antigravity-fhs
  ];
}
