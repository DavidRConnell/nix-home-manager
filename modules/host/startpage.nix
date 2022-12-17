{ ... }:

{
  virtualisation.oci-containers.containers."flame" = {
    autoStart = true;
    image = "pawelmalak/flame:latest";
    ports = [ "8080:5005" ];
    volumes = [ "/data/flame/data:/app/data" ];
    environment = { PASSWORD = "password"; };
  };
}
