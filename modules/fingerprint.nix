# modules/fingerprint.nix
{ config, pkgs, ... }:

{
  # ===== HABILITAR SERVICIO DE HUELLA =====
  services.fprintd.enable = true;
  services.fprintd.tod.enable = false;
  # ===== AUTENTICACIÓN POR HUELLA =====
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = false; 
  };
}
