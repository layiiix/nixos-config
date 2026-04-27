{ pkgs, config, ...}:
{
    programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        languagePacks = [ "es_ES" ];
        
        #Extensiones xd
        policies = {
            ExtensionSettings = {
                "*".installation_mode = "allowed";
        };
       };
    };
}
