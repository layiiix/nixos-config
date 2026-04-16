{ ... }:

{
  programs.librewolf = {
    enable = true;
    languagePacks = [ "es,ES"];
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };
}
