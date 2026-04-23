{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose ];

  # =======================================================================
  # CONFIGURACIÓN DECLARATIVA (NixOS oci-containers)
  # =======================================================================
  virtualisation.oci-containers.backend = "docker";

  # Red de docker para que Traefik pueda ver los contenedores
  systemd.services."docker-network-media" = {
    description = "Create docker network for media stack";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    before = [
      "docker-traefik.service"
      "docker-jellyfin.service"
      "docker-jellyseerr.service"
      "docker-prowlarr.service"
      "docker-radarr.service"
      "docker-sonarr.service"
      "docker-qbittorrent.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.docker}/bin/docker network create media || true";
    };
  };

  virtualisation.oci-containers.containers = {
    traefik = {
      image = "traefik:v3.0";
      ports = [ "80:80" "443:443" "8080:8080" ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      cmd = [
        "--api.insecure=true"
        "--providers.docker=true"
        "--providers.docker.exposedbydefault=false"
        "--entrypoints.web.address=:80"
      ];
      extraOptions = [ "--network=media" ];
    };

    jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = { PUID = "1000"; PGID = "1000"; TZ = "Europe/Madrid"; };
      volumes = [ "/media/jellyfin/config:/config" "/media/tv:/data/tvshows" "/media/movies:/data/movies" ];
      ports = [ "8096:8096" ];
      extraOptions = [ "--network=media" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin.local`)";
        "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
      };
    };

    jellyseerr = {
      image = "fallenbagel/jellyseerr:latest";
      environment = { PUID = "1000"; PGID = "1000"; TZ = "Europe/Madrid"; };
      volumes = [ "/media/jellyseerr/config:/app/config" ];
      ports = [ "5055:5055" ];
      extraOptions = [ "--network=media" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.jellyseerr.rule" = "Host(`jellyseerr.local`)";
        "traefik.http.services.jellyseerr.loadbalancer.server.port" = "5055";
      };
    };

    prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      environment = { PUID = "1000"; PGID = "1000"; TZ = "Europe/Madrid"; };
      volumes = [ "/media/prowlarr/config:/config" ];
      ports = [ "9696:9696" ];
      extraOptions = [ "--network=media" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.prowlarr.rule" = "Host(`prowlarr.local`)";
        "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
      };
    };

    radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      environment = { PUID = "1000"; PGID = "1000"; TZ = "Europe/Madrid"; };
      volumes = [ "/media/radarr/config:/config" "/media/movies:/data/movies" ];
      ports = [ "7878:7878" ];
      extraOptions = [ "--network=media" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.radarr.rule" = "Host(`radarr.local`)";
        "traefik.http.services.radarr.loadbalancer.server.port" = "7878";
      };
    };

    sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      environment = { PUID = "1000"; PGID = "1000"; TZ = "Europe/Madrid"; };
      volumes = [ "/media/sonarr/config:/config" "/media/tv:/data/tvshows" ];
      ports = [ "8989:8989" ];
      extraOptions = [ "--network=media" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.sonarr.rule" = "Host(`sonarr.local`)";
        "traefik.http.services.sonarr.loadbalancer.server.port" = "8989";
      };
    };

    qbittorrent = {
      image = "lscr.io/linuxserver/qbittorrent:latest";
      environment = { PUID = "1000"; PGID = "1000"; TZ = "Europe/Madrid"; WEBUI_PORT = "8080"; };
      volumes = [ "/media/qbittorrent/config:/config" "/media/downloads:/data/downloads" ];
      ports = [ "8081:8080" "6881:6881" "6881:6881/udp" ];
      extraOptions = [ "--network=media" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.qbittorrent.rule" = "Host(`qbittorrent.local`)";
        "traefik.http.services.qbittorrent.loadbalancer.server.port" = "8080";
      };
    };
  };

  # =======================================================================
  # ARCHIVO DOCKER-COMPOSE DE EJEMPLO (Para referencia)
  # =======================================================================
  environment.etc."docker-media/docker-compose.yml".text = ''
    version: '3.8'

    services:
      traefik:
        image: traefik:v3.0
        ports:
          - "80:80"
          - "443:443"
          - "8080:8080"
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock:ro
        command:
          - "--api.insecure=true"
          - "--providers.docker=true"
          - "--providers.docker.exposedbydefault=false"
          - "--entrypoints.web.address=:80"
        networks:
          - media

      jellyfin:
        image: lscr.io/linuxserver/jellyfin:latest
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Madrid
        volumes:
          - /media/jellyfin/config:/config
          - /media/tv:/data/tvshows
          - /media/movies:/data/movies
        ports:
          - "8096:8096"
        networks:
          - media
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.jellyfin.rule=Host(`jellyfin.local`)"
          - "traefik.http.services.jellyfin.loadbalancer.server.port=8096"

      jellyseerr:
        image: fallenbagel/jellyseerr:latest
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Madrid
        volumes:
          - /media/jellyseerr/config:/app/config
        ports:
          - "5055:5055"
        networks:
          - media
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.jellyseerr.rule=Host(`jellyseerr.local`)"
          - "traefik.http.services.jellyseerr.loadbalancer.server.port=5055"

      prowlarr:
        image: lscr.io/linuxserver/prowlarr:latest
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Madrid
        volumes:
          - /media/prowlarr/config:/config
        ports:
          - "9696:9696"
        networks:
          - media
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.prowlarr.rule=Host(`prowlarr.local`)"
          - "traefik.http.services.prowlarr.loadbalancer.server.port=9696"

      radarr:
        image: lscr.io/linuxserver/radarr:latest
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Madrid
        volumes:
          - /media/radarr/config:/config
          - /media/movies:/data/movies
        ports:
          - "7878:7878"
        networks:
          - media
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.radarr.rule=Host(`radarr.local`)"
          - "traefik.http.services.radarr.loadbalancer.server.port=7878"

      sonarr:
        image: lscr.io/linuxserver/sonarr:latest
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Madrid
        volumes:
          - /media/sonarr/config:/config
          - /media/tv:/data/tvshows
        ports:
          - "8989:8989"
        networks:
          - media
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.sonarr.rule=Host(`sonarr.local`)"
          - "traefik.http.services.sonarr.loadbalancer.server.port=8989"

      qbittorrent:
        image: lscr.io/linuxserver/qbittorrent:latest
        environment:
          - PUID=1000
          - PGID=1000
          - TZ=Europe/Madrid
          - WEBUI_PORT=8080
        volumes:
          - /media/qbittorrent/config:/config
          - /media/downloads:/data/downloads
        ports:
          - "8081:8080"
          - "6881:6881"
          - "6881:6881/udp"
        networks:
          - media
        labels:
          - "traefik.enable=true"
          - "traefik.http.routers.qbittorrent.rule=Host(`qbittorrent.local`)"
          - "traefik.http.services.qbittorrent.loadbalancer.server.port=8080"

    networks:
      media:
        name: media
  '';
}
