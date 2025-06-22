{ ... }:

{
  services.caddy.virtualHosts = {
    "http://trap.home".extraConfig = ''
      @blocked not remote_ip 192.168.0.100 192.168.0.103 192.168.0.104
      respond @blocked "Forbidden" 403
      reverse_proxy 127.0.0.1:8082
    '';

    "http://mirrors.home".extraConfig = ''
      encode
      try_files {path} {path}/ =404
      root * /data/mirrors
      file_server
    '';
  };
}
