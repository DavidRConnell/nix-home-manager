{ name, subdomain, tld, users, port, hostAddress, localAddress }: {
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
      users = users;

      services."${name}" = {
        enable = true;
        package = pkgs.searxng;
        environmentFile = "/var/lib/${name}/env.txt";
        settings = {
          search = { autocomplete = "duckduckgo"; };
          server = {
            inherit port;
            base_url = "http://${subdomain}.${tld}";
            bind_address = localAddress;
            secret_key = "@SEARX_SECRET_KEY@";
          };
          redis.url = "unix:///run/redis-${name}/redis.sock?db=0";
          ui.query_in_title = true;
          enabled_plugins = [ "Open Access DOI rewrite" "Vim-like hotkeys" ];
          engines = [
            {
              name = "bitbucket";
              disabled = false;
            }
            {
              name = "gitlab";
              disabled = false;
            }
            {
              name = "google";
              disabled = true;
            }
            {
              name = "google scholar";
              shortcut = "scholar";
              categories = [ "science" "article" ];
            }
            {
              name = "pubmed";
              categories = [ "science" "article" ];
            }
            {
              name = "arxiv";
              categories = [ "science" "article" ];
            }
            {
              name = "marginalla";
              disabled = false;
            }
            {
              name = "wilby";
              disabled = false;
            }
            {
              name = "currency";
              disabled = true;
            }
          ];
        };
      };

      services.redis.servers."${name}" = {
        enable = true;
        user = "${name}";
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
    };
  };
}
