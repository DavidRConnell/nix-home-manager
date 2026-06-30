{ ... }:

{
  services.caddy = { enable = true; };

  services.caddy.virtualHosts = {
    "http://tg.test".extraConfig = ''
      @blocked not remote_ip 192.168.0.101 192.168.0.103 192.168.0.104
      respond @blocked "Forbidden" 403
      reverse_proxy 127.0.0.1:7860
    '';
    "http://back.test".extraConfig = ''
      @blocked not remote_ip 192.168.0.100 192.168.0.103 192.168.0.104
      respond @blocked "Forbidden" 403
      reverse_proxy 127.0.0.1:8000
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
}
