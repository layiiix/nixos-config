{ pkgs, inputs, ... }:

let
  helium = inputs.helium.packages.${pkgs.system}.default;
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
