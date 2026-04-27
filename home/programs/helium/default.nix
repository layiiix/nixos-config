{ pkgs, inputs, lib, ... }:

let
  helium = inputs.helium.packages.${pkgs.system}.default;

  # Extensiones a instalar automáticamente.
  # El ID se saca de la URL de la Chrome Web Store:
  # https://chromewebstore.google.com/detail/nombre/ESTE_ES_EL_ID
  extensions = [
    # uBlock Origin
    "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    # Bitwarden
    "nngceckbapebfimnlniiiahkandclblb"
    # Dark Reader
    # "eimadpbcbfnmbkopoojfekhnkhdbieeh"
  ];

  # Genera el JSON de políticas con las extensiones
  extensionPolicy = builtins.toJSON {
    ExtensionInstallForcelist = map (id: "${id};https://clients2.google.com/service/update2/crx") extensions;
    ExtensionInstallAllowlist = extensions;
  };
in
{
  # Wrapper de Helium con idioma español
  home.packages = [
    (pkgs.symlinkJoin {
      name = "helium";
      paths = [ helium ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/helium \
          --add-flags "--lang=es-ES" \
          --add-flags "--accept-lang=es-ES,es"
      '';
    })
  ];

  # Políticas de Chromium para instalar extensiones automáticamente
  # Helium usa el directorio de políticas de Chromium
  xdg.configFile."helium/policies/managed/extensions.json".text = extensionPolicy;

  # Entrada de escritorio personalizada con flags de idioma
  xdg.desktopEntries.helium = {
    name = "Helium";
    genericName = "Navegador Web";
    comment = "Accede a Internet";
    exec = "helium --lang=es-ES --accept-lang=es-ES,es %U";
    icon = "helium";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/xml"
      "application/rss+xml"
      "application/rdf+xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
      "x-scheme-handler/chrome"
      "video/webm"
      "application/x-xpinstall"
    ];
  };
}
