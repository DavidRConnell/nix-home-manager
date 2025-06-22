final: prev: {
  lib = prev.lib // {
    mkVHost = { subdomain, port ? "443", domain ? "home", url ? "127.0.0.1"
      , tls ? false }: {
        "${if tls then "" else "http://"}${subdomain}.${domain}".extraConfig =
          ''
            reverse_proxy ${url}:${port}
            ${if tls then "tls internal" else ""}
          '';
      };

    mkDockerBridge = { subdomain }: {
      "init-${subdomain}-network" = let docker = "${prev.docker}/bin/docker";
      in {
        description = "Create the network bridge for ${subdomain}.";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig.Type = "oneshot";
        script = ''
          # Put a true at the end to prevent getting non-zero return code, which will
          # crash the whole service.
          check=$(${docker} network ls | grep "${subdomain}-bridge" || true)
          if [ -z "$check" ]; then
            ${docker} network create ${subdomain}-bridge
          else
            echo "${subdomain}-bridge already exists in docker"
          fi
        '';
      };
    };
  };
}
