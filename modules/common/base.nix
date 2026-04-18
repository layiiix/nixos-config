# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =   [ ./cachix.nix ];
    #  ./hardware-configuration.nix
     # ../../modules/common/base.nix
      #../../modules/desktop.nix
      #../../modules/hardware/nvidia.nix
      #../../modules/gaming.nix
    #];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable =true;
  services.xserver.enable = true;

  services.displayManager.sddm = {
   enable = true;
   wayland.enable = false;
   theme = "catppuccin-mocha-mauve";
   package = pkgs.kdePackages.sddm;
  };


 # networking.hostName = "desktop"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";
   
 # programs.niri = {
#  enable = true;
  #package = inputs.niri.packages.${pkgs.system}.niri-stable;
#};
 programs.niri.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";
   console = {
     keyMap = "es";
     useXkbConfig = false; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  xdg.portal = {
  enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
  ];
  # config.common.default = [ "wlr" ];
};

  #NIX
  nix.settings = {
    extra-substituters = [ "https://niri.cachix.org" ];
    extra-trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.supportedFilesystems = [ "btrfs" ];
  nix.gc = {
   automatic = true;
   dates = "daily";
   options = "--delete-older-than-3d";
  };
  programs.nix-ld.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
   security.rtkit.enable = true;
   services.pipewire = {
     enable = true;
     alsa.enable =true;
     alsa.support32Bit = true;
     pulse.enable = true;
   };
   services.fwupd = {
     enable = true;
   };
   services.upower = {
       enable = true;
    };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.layiiesp = {
   #  isNormalUser = true;
   #  extraGroups = [ "wheel" "video" "audio" ]; # Enable ‘sudo’ for the user.
   # enviroment.systemPackages = with pkgs; [
    #tree
     #];
  # };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.udisks2.enable = true;
  # programs.firefox.enable = true;
 # programs.regreet.enable =true;
 # services.greetd = {
  #  enable = true;
   # settings = {
    # default_session = {
     # command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
      #user = "greeter";
    # };
    #};
   #};
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     curl
     htop
     udiskie
     vlc
     yazi
     kdePackages.dolphin
     wl-clipboard
     xwayland-satellite
     unzip
     zip
     p7zip
     unrar
     python3
     grim
     slurp
     catppuccin-sddm
     localsend
     
     
   ];
  #Fonts
   fonts.packages = with pkgs; [
     jetbrains-mono
     nerd-fonts.jetbrains-mono
     noto-fonts
     noto-fonts-color-emoji
     dejavu_fonts
     liberation_ttf
     freefont_ttf
   ];
  nixpkgs.config.allowUnfree = true; 
# programs.xwayland-satellite.enable = true;
 #programs.niri.enable = true;
 programs.xwayland.enable = true;
 programs.zsh.enable = true;
 users.defaultUserShell = pkgs.zsh;
 # variables entorno
  environment.variables = {
   EDITOR = "nvim";
   VISUAL = "nvim";
   NIXOS_OZONE_WL = "1";
   MOZ_ENABLE_WAYLAND ="1";
  
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # environment.sessionVariables = {
  #XDG_CURRENT_DESKTOP = "sway"; # o "niri" (pero sway es más compatible)
  #};
  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  #Puertos : localsend
  networking.firewall.allowedTCPPorts = [53317 22 ];
  networking.firewall.allowedUDPPorts = [ 53317 22 ];
  # Or disable the firewall altogether.
   networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

