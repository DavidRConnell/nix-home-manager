{ ... }:

{
  virtualisation.oci-containers.containers."audiobook" = {
    autoStart = true;
    image = "ghcr.io/advplyr/audiobookshelf";
    ports = [ "8083:80" ];
    volumes = [
      "/data/audiobook/config:/config"
      "/data/audiobook/metadata:/metadata"
      "/data/audiobook/audiobooks:/audiobooks"
      "/data/audiobook/podcasts:/podcasts"
    ];
  };
}
