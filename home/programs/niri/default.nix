{ config, pkgs, lib, isLaptop ? false, ... }:

let
  mod = "Mod";

  # Mantenemos los colores oscuros al estilo Catppuccin recomendados para programar y cuidar la vista.
  # El theme por defecto KDL es muy brillante, este es un acercamiento "Dark/Premium".
  bg = "#1e1e2e";
  active_color = "#89b4fa";    # Azul suave para el foco activo
  inactive_color = "#585b70";  # Gris para el inactivo
  urgent_color = "#f38ba8";    # Rojo suave para notificaciones urgentes

in
{
  programs.niri = {
    package = pkgs.niri;

    settings = {

      ################################
      # INPUT CONFIGURATION
      ################################
      input = {
        keyboard = {
          xkb = {
            layout = "es";
            options = "caps:escape";
          };
          # Uncomment for numlock on startup
          # numlock = true;
        };

        # Habilitar opciones de Touchpad sólo para portátiles
        touchpad = if isLaptop then {
          tap = true;
          natural-scroll = true;
          # dwt = true;
          # dwtp = true;
        } else {};

        mouse = {
          # accel-profile = "flat";
        };

        trackpoint = {
          # natural-scroll = true;
        };

        # focus-follows-mouse.max-scroll-amount = "0%";
      };

      ################################
      # OUTPUTS CONFIGURATION
      ################################
      outputs = if isLaptop then {
        "eDP-1" = {
          scale = 1.0; 
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.0;
          };
        };
      } else {};

      ################################
      # LAYOUT & WINDOWS
      ################################
      layout = {
        gaps = 16;
        center-focused-column = "never";

        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width = { proportion = 0.5; };

        focus-ring = {
          enable = true;
          width = 4;
          active.color = active_color;
          inactive.color = inactive_color;
        };

        border = {
          enable = false; # Desactivado por defecto a favor del focus-ring
          width = 4;
          active.color = active_color;
          inactive.color = inactive_color;
          urgent.color = urgent_color;
        };

        shadow = {
          enable = false; # Cambiar a true para sombras
          softness = 30;
          spread = 5;
          offset = { x = 0; y = 5; };
          color = "#0007";
        };

        # struts = { left = 64; right = 64; top = 64; bottom = 64; };
      };

      ################################
      # AUTOSTART & SYSTEM
      ################################
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];

      hotkey-overlay = {
        # skip-at-startup = true;
      };

      # prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      animations = {
        enable = true;
        # slowdown = 3.0;
      };

      ################################
      # WINDOW RULES
      ################################
      window-rules = [
        {
          # Workaround para Wezterm
          matches = [{ app-id = "^org\\.wezfurlong\\.wezterm$"; }];
          # default-column-width = {}; 
        }
        {
          # Firefox Picture-in-Picture flotante por defecto
          matches = [
            { app-id = "firefox$"; title = "^Picture-in-Picture$"; }
            { app-id = "org\\.mozilla\\.firefox$"; title = "^Picture-in-Picture$"; }
          ];
          open-floating = true;
        }
      ];

      ################################
      # BINDS 
      ################################
      binds = {
        # === SUPERPOSICIÓN E INFORMACIÓN ===
        "${mod}+Shift+Slash".action.show-hotkey-overlay = {};

        # === APLICACIONES BÁSICAS ===
        "${mod}+t".action.spawn = "wezterm"; # Reemplaza el alacritty original en tu config
        "${mod}+d".action.spawn = "fuzzel";
        "Super+Alt+L".action.spawn = "swaylock";

        # === AUDIO & BRILLO ===
        "XF86AudioRaiseVolume" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" "-l" "1.0" ]; };
        "XF86AudioLowerVolume" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ]; };
        "XF86AudioMute" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; };
        "XF86AudioMicMute" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ]; };

        "XF86AudioPlay" = { allow-when-locked = true; action.spawn = [ "playerctl" "play-pause" ]; };
        "XF86AudioStop" = { allow-when-locked = true; action.spawn = [ "playerctl" "stop" ]; };
        "XF86AudioPrev" = { allow-when-locked = true; action.spawn = [ "playerctl" "previous" ]; };
        "XF86AudioNext" = { allow-when-locked = true; action.spawn = [ "playerctl" "next" ]; };

        "XF86MonBrightnessUp" = { allow-when-locked = true; action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ]; };
        "XF86MonBrightnessDown" = { allow-when-locked = true; action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ]; };

        # === OVERVIEW & CERRAR/QUITAR ===
        "${mod}+o".action.toggle-overview = {};
        "${mod}+q".action.close-window = {};
        "${mod}+Shift+e".action.quit = {};
        "Ctrl+Alt+Delete".action.quit = {};
        "${mod}+Shift+p".action.power-off-monitors = {};

        # === MOVIMIENTO DE FOCO ===
        "${mod}+h".action.focus-column-left = {};
        "${mod}+j".action.focus-window-down = {};
        "${mod}+k".action.focus-window-up = {};
        "${mod}+l".action.focus-column-right = {};
        
        "${mod}+Home".action.focus-column-first = {};
        "${mod}+End".action.focus-column-last = {};

        # === MOVER ELEMENTOS (VENTANAS Y COLUMNAS) ===
        "${mod}+Ctrl+h".action.move-column-left = {};
        "${mod}+Ctrl+j".action.move-window-down = {};
        "${mod}+Ctrl+k".action.move-window-up = {};
        "${mod}+Ctrl+l".action.move-column-right = {};

        "${mod}+Ctrl+Home".action.move-column-to-first = {};
        "${mod}+Ctrl+End".action.move-column-to-last = {};

        # === FOCO DE MONITORES ===
        "${mod}+Shift+h".action.focus-monitor-left = {};
        "${mod}+Shift+j".action.focus-monitor-down = {};
        "${mod}+Shift+k".action.focus-monitor-up = {};
        "${mod}+Shift+l".action.focus-monitor-right = {};

        "${mod}+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
        "${mod}+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};
        "${mod}+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
        "${mod}+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
        "${mod}+Shift+Ctrl+h".action.move-column-to-monitor-left = {};
        "${mod}+Shift+Ctrl+j".action.move-column-to-monitor-down = {};
        "${mod}+Shift+Ctrl+k".action.move-column-to-monitor-up = {};
        "${mod}+Shift+Ctrl+l".action.move-column-to-monitor-right = {};

        # === ESPACIOS DE TRABAJO ===
        "${mod}+Page_Down".action.focus-workspace-down = {};
        "${mod}+Page_Up".action.focus-workspace-up = {};
        "${mod}+u".action.focus-workspace-down = {};
        "${mod}+i".action.focus-workspace-up = {};
        
        # Como solicitaste antes, flechas para espacios de trabajo y columnas:
        "${mod}+Left".action.focus-column-left = {};
        "${mod}+Right".action.focus-column-right = {};
        "${mod}+Down".action.focus-workspace-down = {};
        "${mod}+Up".action.focus-workspace-up = {};

        "${mod}+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
        "${mod}+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
        "${mod}+Ctrl+u".action.move-column-to-workspace-down = {};
        "${mod}+Ctrl+i".action.move-column-to-workspace-up = {};

        "${mod}+Shift+Page_Down".action.move-workspace-down = {};
        "${mod}+Shift+Page_Up".action.move-workspace-up = {};
        "${mod}+Shift+u".action.move-workspace-down = {};
        "${mod}+Shift+i".action.move-workspace-up = {};
        
        "${mod}+Shift+Left".action.move-column-left = {};
        "${mod}+Shift+Right".action.move-column-right = {};
        "${mod}+Shift+Down".action.move-window-to-workspace-down = {};
        "${mod}+Shift+Up".action.move-window-to-workspace-up = {};

        # === RATÓN Y TRACKPAD SCROLL ===
        "${mod}+WheelScrollDown" = { cooldown-ms = 150; action.focus-workspace-down = {}; };
        "${mod}+WheelScrollUp" = { cooldown-ms = 150; action.focus-workspace-up = {}; };
        "${mod}+Ctrl+WheelScrollDown" = { cooldown-ms = 150; action.move-column-to-workspace-down = {}; };
        "${mod}+Ctrl+WheelScrollUp" = { cooldown-ms = 150; action.move-column-to-workspace-up = {}; };

        "${mod}+WheelScrollRight".action.focus-column-right = {};
        "${mod}+WheelScrollLeft".action.focus-column-left = {};
        "${mod}+Ctrl+WheelScrollRight".action.move-column-right = {};
        "${mod}+Ctrl+WheelScrollLeft".action.move-column-left = {};

        "${mod}+Shift+WheelScrollDown".action.focus-column-right = {};
        "${mod}+Shift+WheelScrollUp".action.focus-column-left = {};
        "${mod}+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
        "${mod}+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

        # === ESPACIOS DE TRABAJO (Índices y Movimiento) ===
        "${mod}+1".action.focus-workspace = 1;
        "${mod}+2".action.focus-workspace = 2;
        "${mod}+3".action.focus-workspace = 3;
        "${mod}+4".action.focus-workspace = 4;
        "${mod}+5".action.focus-workspace = 5;
        "${mod}+6".action.focus-workspace = 6;
        "${mod}+7".action.focus-workspace = 7;
        "${mod}+8".action.focus-workspace = 8;
        "${mod}+9".action.focus-workspace = 9;

        "${mod}+Ctrl+1".action.move-column-to-workspace = 1;
        "${mod}+Ctrl+2".action.move-column-to-workspace = 2;
        "${mod}+Ctrl+3".action.move-column-to-workspace = 3;
        "${mod}+Ctrl+4".action.move-column-to-workspace = 4;
        "${mod}+Ctrl+5".action.move-column-to-workspace = 5;
        "${mod}+Ctrl+6".action.move-column-to-workspace = 6;
        "${mod}+Ctrl+7".action.move-column-to-workspace = 7;
        "${mod}+Ctrl+8".action.move-column-to-workspace = 8;
        "${mod}+Ctrl+9".action.move-column-to-workspace = 9;
        
        "${mod}+Shift+1".action.move-window-to-workspace = 1;
        "${mod}+Shift+2".action.move-window-to-workspace = 2;
        "${mod}+Shift+3".action.move-window-to-workspace = 3;
        "${mod}+Shift+4".action.move-window-to-workspace = 4;
        "${mod}+Shift+5".action.move-window-to-workspace = 5;
        "${mod}+Shift+6".action.move-window-to-workspace = 6;
        "${mod}+Shift+7".action.move-window-to-workspace = 7;
        "${mod}+Shift+8".action.move-window-to-workspace = 8;
        "${mod}+Shift+9".action.move-window-to-workspace = 9;

        # === RE-ACOMPODAR COLUMNAS ===
        "${mod}+BracketLeft".action.consume-or-expel-window-left = {};
        "${mod}+BracketRight".action.consume-or-expel-window-right = {};
        "${mod}+Comma".action.consume-window-into-column = {};
        "${mod}+Period".action.expel-window-from-column = {};

        # === AJUSTES DIMENSIONALES ===
        "${mod}+r".action.switch-preset-column-width = {};
        "${mod}+Shift+r".action.switch-preset-window-height = {};
        "${mod}+Ctrl+r".action.reset-window-height = {};
        "${mod}+f".action.maximize-column = {};
        "${mod}+Shift+f".action.fullscreen-window = {};
        # "${mod}+m".action.maximize-window-to-edges = {}; # Acción no soportada en esta versión de niri
        "${mod}+Ctrl+f".action.expand-column-to-available-width = {};
        "${mod}+c".action.center-column = {};
        "${mod}+Ctrl+c".action.center-visible-columns = {};

        "${mod}+Minus".action.set-column-width = "-10%";
        "${mod}+Equal".action.set-column-width = "+10%";
        "${mod}+Shift+Minus".action.set-window-height = "-10%";
        "${mod}+Shift+Equal".action.set-window-height = "+10%";

        # === FLOTANCIA & VISTAS ===
        "${mod}+v".action.toggle-window-floating = {};
        "${mod}+Shift+v".action.switch-focus-between-floating-and-tiling = {};
        "${mod}+w".action.toggle-column-tabbed-display = {};

        # === CAPTURAS ===
        "Print".action.screenshot = {};
        "Ctrl+Print".action.screenshot-screen = {};
        "Alt+Print".action.screenshot-window = {};

        # === SEGURIDAD INHIBIDORA ===
        "${mod}+Escape" = { allow-inhibiting = false; action.toggle-keyboard-shortcuts-inhibit = {}; };
      };
    };
  };
}
