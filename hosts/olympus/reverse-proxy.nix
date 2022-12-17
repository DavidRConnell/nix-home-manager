{ ... }:

{
  services.nginx = {
    recommendedProxySettings = true;
    enable = true;
    virtualHosts = {
      "start.home".locations."/".proxyPass = "http://127.0.0.1:8080";
      "adguard.home".locations."/".proxyPass = "http://127.0.0.1:8081";
      "trap.home".locations."/".proxyPass = "http://127.0.0.1:8082";
      "audio.home".locations."/".proxyPass = "http://127.0.0.1:8083";
      "jellyfin.home".locations."/".proxyPass = "http://127.0.0.1:8084";
      "gitea.home".locations."/".proxyPass = "http://127.0.0.1:8085";
      "metube.home".locations."/".proxyPass = "http://127.0.0.1:8086";
    };
  };
}
