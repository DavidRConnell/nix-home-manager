{ ... }:

{
  virtualisation.oci-containers.containers."gitlab" = {
    autoStart = true;
    image = "gitlab/gitlab-ce:latest";
    environment = { GITLAB_OMNIBUS_CONFIG = "external_url 'localhost:8085"; };
    ports = [ "443:443" "8085:8085" "22:22" ];
    volumes = [
      "/data/gitlab/config:/etc/gitlab"
      "/var/logs/gitlab:/var/log/gitlab"
      "/data/gitlab/data:/var/opt/gitlab"
    ];
  };
}
