{ ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts = {
      # "adguard.home" = { locations."/".proxyPass = "http://127.0.0.1:8081"; };
      "trap.home" = { locations."/".proxyPass = "http://127.0.0.1:8082"; };
      # "audio.home" = { locations."/".proxyPass = "http://127.0.0.1:8083"; };
      "jellyfin.home" = { locations."/".proxyPass = "http://127.0.0.1:8084"; };
      # "gitlab.home" = { locations."/".proxyPass = "http://127.0.0.1:8085"; };
    };
  };
}
