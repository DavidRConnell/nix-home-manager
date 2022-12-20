final: prev: {
  lib = prev.lib // {
    mkVHost = { subdomain, port, domain ? "home" }: {
      "${subdomain}.${domain}".locations."/".proxyPass =
        "http://127.0.0.1:${port}";
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
