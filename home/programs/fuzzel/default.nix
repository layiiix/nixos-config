{ isLaptop, ... }:
let
  fontSize = if isLaptop then "16" else "26";
  fuzzelWidth = if isLaptop then 30 else 40;
in
{
  programs.fuzzel = {
   enable = true;
   settings = {
     main = {
       font = "JetBrainsMono Nerd Font:size=${fontSize}";
       width = fuzzelWidth;
       lines = 10;
     };   
    };
   };
}
