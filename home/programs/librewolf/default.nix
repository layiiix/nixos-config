{ ... }:

{
  programs.librewolf = {
    enable = true;
    languagePacks = [ "es,ES"];
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "browser.ml.enable" = false;
      "browser.ml.chat.enabled" = false;
    };
  };
}
