{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "calibre";
  port = "9100";
  dataPath = "/data/calibre";
in {
  services.caddy.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "crocodilestick/calibre-web-automated:latest";
      ports = [ "${port}:8083" ];
      volumes = [
        "${dataPath}/config:/config"
        "${dataPath}/library:/calibre-library"
        "${dataPath}/ingest:/cwa-book-ingest"
      ];

      environment = {
        PUID = "1000";
        PGID = "100";
        # TZ = "";
      };
    };
  };
}
