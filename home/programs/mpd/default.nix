{ pkgs, ... }:

{
  home.packages = with pkgs; [
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };
}
