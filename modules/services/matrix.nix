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
        hostPath = "/data/${subdomain}/matrix";
        isReadOnly = false;
      };
      "/var/lib/postgres" = {
        hostPath = "/data/${subdomain}/postgres";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      inherit users;

      systemd.tmpfiles.rules = [
        "d /var/lib/postgres 700 postgres postgres -"
        "d /var/lib/${name} 700 ${name} ${name} -"
      ];

      services.nginx =
        let
          baseUrl = "http://${subdomain}.home";
          clientConfig."m.homeserver".base_url = baseUrl;
          serverConfig."m.server" = "${subdomain}:${builtins.toString port}";
          mkWellKnown = data: ''
            default_type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON data}';
          '';
        in
        {
          enable = true;
          recommendedTlsSettings = true;
          recommendedOptimisation = true;
          recommendedGzipSettings = true;
          recommendedProxySettings = true;
          defaultListen = [
            {
              inherit port;
              addr = localAddress;
            }
          ];
          virtualHosts = {
            "${subdomain}.home" = {
              locations."/".proxyPass = "http://127.0.0.1:8008";
              locations."/_matrix".proxyPass = "http://127.0.0.1:8008";
              locations."/_synapse/client".proxyPass = "http://127.0.0.1:8008";
              locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
              locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
            };
          };
        };

      services.matrix-synapse = {
        enable = true;
        settings = {
          server_name = "${subdomain}.home";
          public_baseurl = "http://${subdomain}.home";
          registration_shared_secret = "password";
        };
        settings.listeners = [
          {
            port = 8008;
            bind_addresses = [ "127.0.0.1" ];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
              {
                names = [
                  "client"
                  "federation"
                ];
                compress = true;
              }
            ];
          }
        ];
      };

      services.postgresql = {
        enable = true;
        dataDir = "/var/lib/postgres";
        ensureUsers = [
          {
            name = "matrix-synapse";
            ensureDBOwnership = true;
            ensureClauses.login = true;
          }
        ];
        ensureDatabases = [ "matrix-synapse" ];
        initialScript = pkgs.writeText "init-sql-script" ''
          CREATE ROLE "matrix-synapse";
          CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
            TEMPLATE template0
            LC_COLLATE = "C"
            LC_CTYPE = "C";
        '';
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
    };
  };
}
