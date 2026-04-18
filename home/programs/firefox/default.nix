{ pkgs, config, ...}:
{
    programs.firefox = {
        enable = true;
        languagePacks = [ "es_ES" ];
        
        #Extensiones xd
        ExtensionSettings = {
            "*".installation_mode = "allowed";
        };
    };
}
