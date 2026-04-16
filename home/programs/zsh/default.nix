{ config, pkgs, ... }:

{
  # Activar LSD: Reemplazo para 'ls' escrito en Rust con iconos
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  # Activar Zoxide: Un comando 'cd' ultrasmart ("z" command)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Activar Starship: Prompt super completo (Detecta Python, Nix, Git, etc automáticamente)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      python = {
        symbol = "🐍 ";
        format = "via [\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style)";
      };
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \\($name\\))]($style) ";
      };
    };
  };

  # Configuración Principal de Zsh
  programs.zsh = {
    enable = true;
    
    # Autocompletado del sistema (hace llamadas automáticas a 'compinit' de forma optimizada)
    enableCompletion = true;

    # Historial de comandos guardado en archivo
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    # Atajos de terminal adicionales o ligeras mejoras visuales
    initExtra = ''
      # Búsqueda en el historial escribiendo y luego usando flechas arriba/abajo
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';

    # 🚀 ANTIDOTE: Tu gestor de plugins directo de GitHub
    antidote = {
      enable = true;
      plugins = [
        # --- Indispensables ZSH ---
        "zsh-users/zsh-autosuggestions"         # Sugerencias fantasma de lo que escribiste antes
        "zsh-users/zsh-syntax-highlighting"     # Resalta los comandos verde/rojo si existen o no
        "zsh-users/zsh-completions"             # Completados extra con tabulador para miles de apps
        
        # --- Desde el ecosistema OhMyZsh ---
        # Usamos Antidote para sacar plugins específicos de ohmyzsh sin instalar todo el framework
        "ohmyzsh/ohmyzsh path:plugins/git"      # Alias y autocompletados extra para Git
        "ohmyzsh/ohmyzsh path:plugins/python"   # Alias útiles para el ecosistema python
        "ohmyzsh/ohmyzsh path:plugins/pip"      # Autocompletado rápido para PIP
        "ohmyzsh/ohmyzsh path:plugins/extract"  # Añade comando `extract archivo.zip/.tar.gz` mágico
        "ohmyzsh/ohmyzsh path:plugins/sudo"     # Pulsar 2 veces ESC añade 'sudo ' al inicio
      ];
    };

    # Alias útiles que te mejoran la vida
    shellAliases = {
      c = "clear";
      py = "python3";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config"; # ¡Ojo! Sin especificar el host, pon #desktop o #laptop si hace falta.
    };
  };
}
