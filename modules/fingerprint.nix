# modules/fingerprint.nix
{ config, pkgs, ... }:

{
  # ===== HABILITAR SERVICIO DE HUELLA =====
  services.fprintd.enable = true;

  # ===== AUTENTICACIÓN POR HUELLA =====
  security.pam.services = {
    login.fprintAuth = true;    # Huella para login
  };
}
