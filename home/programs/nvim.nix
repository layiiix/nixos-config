{ ... }:
{
    programs.neovim = {
       enable = true;
       defaultEditor = true;
       initLua = "";
       extraConfig = ''
         set clipboard=unnamedplus
       '';
     };
}

