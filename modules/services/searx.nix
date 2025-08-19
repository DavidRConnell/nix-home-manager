{ name, subdomain, package, tld, users, environment, port, hostAddress
, localAddress }: {
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
      inherit users environment;

      services.searx = {
        enable = true;
        package = package;
        environmentFile = "/var/lib/${name}/env.txt";
        settings = {
          search = {
            autocomplete = "duckduckgo";
            default_lang = "en-US";
            languages = [ "all" "en" "en-US" ];
          };

          server = {
            inherit port;
            base_url = "http://${subdomain}.${tld}";
            bind_address = localAddress;
            secret_key = "@SEARX_SECRET_KEY@";
          };

          redis.url = "unix:///run/redis-${name}/redis.sock?db=0";
          enabled_plugins = [
            "Open Access DOI rewrite"
            "Vim-like hotkeys"
            "Search on category select"
            # "Tracker URL remover"
          ];

          engines = [
            # general
            {
              name = "google";
              disabled = true;
            }
            {
              name = "duckduckgo";
              disabled = false;
            }
            {
              name = "presearch";
              disabled = false;
            }
            {
              name = "mojeek";
              disabled = true;
            }
            {
              name = "ddg definitions";
              disabled = false;
            }
            {
              name = "marginalia";
              disabled = true;
            }
            {
              name = "yahoo";
              disabled = false;
            }
            {
              name = "wiby";
              disabled = true;
            }
            {
              name = "currency";
              disabled = true;
            }
            {
              name = "qwant";
              disabled = true;
            }
            {
              name = "alexendria";
              disabled = false;
            }
            {
              name = "startpage";
              disabled = true;
            }
            {
              name = "brave";
              disabled = false;
            }
            # images
            {
              name = "google images";
              disabled = false;
            }
            {
              name = "bing images";
              disabled = false;
            }
            {
              name = "qwant images";
              disabled = false;
            }
            {
              name = "artic";
              disabled = true;
            }
            {
              name = "flickr";
              disabled = true;
            }
            {
              name = "library of congress";
              disabled = true;
            }
            # videos
            {
              name = "google videos";
              disabled = true;
            }
            {
              name = "bing videos";
              disabled = false;
            }
            # it
            {
              name = "bitbucket";
              disabled = false;
            }
            {
              name = "gitlab";
              disabled = false;
            }
            {
              name = "codeberg";
              disabled = false;
            }
            {
              name = "sourcehut";
              disabled = false;
            }
            {
              name = "hoogle";
              disabled = true;
            }
            # science
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
          ];

          hostnames = {
            replace = { "(.*.)?reddit.com" = "redlib.home"; };

            remove = [
              "(.*.)?facebook.com$"
              "(.*.)?instagram.com$"
              "(.*.)?medium.com$"
              "(.*.)?geeksforgeeks.com$"
              "(.*.)?linkedin.com$"
              "(.*.)?researchgate.net"
              "(.*.)?kaggle.com$"
              "(.*.)?pintrest.com$"
              "(.*.)?twitter.com$"
              "(.*.)?x.com$"
              "(.*.)?wikihow.com$"
            ];
          };
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
