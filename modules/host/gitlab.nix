{ ... }:

{
  virtualisation.oci-containers.containers."gitlab" = {
    autoStart = true;
    image = "gitlab/gitlab-ce:latest";
    # hostname = "gitlab.home";
    ports = [ "443:443" "8085:80" "22:22" ];
    volumes = [
      "/data/gitlab/config:/etc/gitlab"
      "/var/logs/gitlab:/var/log/gitlab"
      "/data/gitlab/data:/var/opt/gitlab"
    ];
  };
}
