{config, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = "schedutil";
  environment.systemPackages = with pkgs; [
    vesktop
    kdePackages.kdenlive
    virtualbox
    antigravity-fhs
    davinci-resolve
    (kodi-wayland.withPackages (kodiPkgs: [
      python3Packages.pycryptodome
      python3Packages.pycryptodomex
    ]))
  ];
}
