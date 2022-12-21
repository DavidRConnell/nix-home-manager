{ ... }:

{
  virtualisation.oci-containers.containers."gitlab" = {
    autoStart = true;
    image = "gitlab/gitlab-ce:latest";
    ports = [ "443:443" "8085:80" "2222:22" ];
    volumes = [
      "/data/gitlab/config:/etc/gitlab"
      "/var/logs/gitlab:/var/log/gitlab"
      "/data/gitlab/data:/var/opt/gitlab"
    ];
  };
}
