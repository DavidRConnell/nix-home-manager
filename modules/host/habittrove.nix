{ pkgs, ... }:

let
  mkVHost = pkgs.lib.mkVHost;
  subdomain = "habittrove";
  port = "9080";
  dataPath = "/data/habittrove";
in {
  services.caddy.virtualHosts = mkVHost { inherit subdomain port; };
  virtualisation.oci-containers.containers = {
    "${subdomain}" = {
      autoStart = true;
      image = "dohsimpson/habittrove:latest";
      ports = [ "${port}:3000" ];
      user = "1000:100";
      volumes =
        [ "${dataPath}/data:/app/data" "${dataPath}/backups:/app/backups" ];
      environment = {
        AUTH_SECRET = ''
          fzSxW56QiSOlh84tN2HW8xRkVoIrnqk5/608oeGkVus=
        '';
      };

    };
  };
}
