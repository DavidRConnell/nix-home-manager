{ ... }:

{
  virtualisation.oci-containers.containers."gitea" = {
    autoStart = true;
    image = "gitea/gitea:latest";
    ports = [ "8085:3000" "2285:22" ];
    volumes = [
      "/data/gitea/data:/data"
      "/etc/timezone:/etc/timezone:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
