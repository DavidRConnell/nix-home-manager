{ ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "5G";
  };

  services.nginx.virtualHosts = {
    "tg.test".locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:7860";
      extraConfig = ''
        allow 192.168.0.100;
        allow 192.168.0.103;
        allow 192.168.0.104;
        deny all;
      '';
    };
    "back.test".locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:8000";
      extraConfig = ''
        allow 192.168.0.100;
        allow 192.168.0.103;
        allow 192.168.0.104;
        deny all;
      '';
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 ];
  };
}
