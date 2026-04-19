{ pkgs, config, ...}:
{
    programs.firefox = {
        enable = true;
        languagePacks = [ "es_ES" ];
        
        #Extensiones xd
        policies = {
            ExtensionSettings = {
                "*".installation_mode = "allowed";
        };
       };
    };
}
