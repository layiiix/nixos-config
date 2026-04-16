{ inputs, pkgs, ... }:

{
  # Cargamos la magia de Nixvim directamente desde tu Flake
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  # Reemplazamos programs.neovim nativo por programs.nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # ==========================
    # Opciones Base de Neovim
    # ==========================
    globals = {
      mapleader = " "; # Tecla líder es el Espacio
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 4;
      tabstop = 4;
      expandtab = true;
      smartindent = true;
      clipboard = "unnamedplus";
      termguicolors = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      signcolumn = "yes";
    };

    # ==========================
    # Tema Base
    # ==========================
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavor = "mocha";
      };
    };

    # ==========================
    # Plugins Core "Estilo LazyVim"
    # ==========================
    plugins = {
      # Visor de Iconos Clásico
      web-devicons.enable = true;

      # Lualine: Barra de estado elegante
      lualine.enable = true;

      # Neo-tree: Árbol lateral de archivos
      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
      };

      # Telescope: Buscador omnipresente con Ctrl+P / find files
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader><space>" = "buffers";
        };
      };

      # Treesitter: Inteligencia de sintaxis para todos los lenguajes
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };

      # Which-key: Chuleta mágica al pulsar espacio
      which-key.enable = true;

      # Autocompletado inteligente
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      # Servidores Inteligentes (LSP) para que entienda tu código
      lsp = {
        enable = true;
        servers = {
          # Inteligencia pura de Python
          pyright.enable = true;
          # Inteligencia pura de Nix (para que tu editor sepa Nix)
          nixd.enable = true;
          # Inteligencia máxima para Rust
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
        keymaps = {
          lspBuf = {
            "K" = "hover";             # Shift+K para ver explicacion de funciones
            "gd" = "definition";       # 'gd' ir a la definicion
            "gD" = "references";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
          };
        };
      };

      # Pantalla de inicio visual y guay similar a Alpha
      alpha = {
        enable = true;
        theme = "dashboard";
      };
    };

    # ==========================
    # Atajos manuales LazyVim
    # ==========================
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options = { desc = "Toggle Explorer"; };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>qa<CR>";
        options = { desc = "Quit all"; };
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<CR>";
        options = { desc = "Buffer Anterior"; };
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        options = { desc = "Buffer Siguiente"; };
      }
    ];

  };
}
