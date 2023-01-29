{ ... }:

{
  services.nginx.virtualHosts = {
    "trap.home".locations."/".proxyPass = "http://127.0.0.1:8082";
    "mirrors.home" = {
      root = "/data/mirrors";
      locations."/".tryFiles = "$uri $uri/ =404";
    };
  };
}
