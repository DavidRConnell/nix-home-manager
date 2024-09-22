{ ... }:

{
  services.nginx.virtualHosts = {
    "trap.home".locations."/" = {
      proxyPass = "http://127.0.0.1:8082";
      extraConfig = ''
        allow 192.168.0.100;
        allow 192.168.0.103;
        allow 192.168.0.104;
        deny all;
      '';
    };
    "mirrors.home" = {
      root = "/data/mirrors";
      locations."/".tryFiles = "$uri $uri/ =404";
    };
  };
}
