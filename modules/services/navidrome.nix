{
  name,
  subdomain,
  users,
  port,
  hostAddress,
  localAddress,
}:
{
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/${name}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users;

      services.navidrome = {
        enable = true;
        user = name;
        group = name;
        settings = {
          Port = port;
          Address = localAddress;
          MusicFolder = "/var/lib/${name}/music";
          FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
        };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
    };
  };
}
