{
  name,
  subdomain,
  package,
  tld,
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
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        inherit users;

        services.searx = {
          enable = true;
          package = package;
          environmentFile = "/var/lib/${name}/env.txt";
          settings = {
            search = {
              autocomplete = "startpage";
              default_lang = "en";
              languages = [
                "all"
                "en"
                "en-US"
              ];
            };

            server = {
              inherit port;
              base_url = "http://${subdomain}.${tld}";
              bind_address = localAddress;
              secret_key = "@SEARX_SECRET_KEY@";
            };

            ui.query_in_title = true;
            redis.url = "unix:///run/redis-${name}/redis.sock?db=0";
            search_on_category_select = true;
            hotkeys = "vim";

            plugins =
              lib.mapAttrs'
                (
                  name: active:
                  lib.nameValuePair "searx.plugins.${name}.SXNGPlugin" {
                    inherit active;
                  }
                )
                {
                  calculator = true;
                  hash_plugin = true;
                  self_info = true;
                  tracker_url_remover = true;
                  unit_converter = true;
                  oa_doi_rewrite = true;
                  hostnames = true;
                };

            engines = [
              # general
              {
                name = "aol";
                disabled = true;
              }
              {
                name = "bing";
                disabled = true;
              }
              {
                name = "brave";
                disabled = false;
              }
              {
                name = "duckduckgo";
                disabled = false;
              }
              {
                name = "google";
                disabled = true;
              }
              {
                name = "mojeek";
                disabled = true;
              }
              {
                name = "karmasearch";
                disabled = true;
              }
              {
                name = "karmasearch videos";
                disabled = true;
              }
              {
                name = "presearch";
                disabled = true;
              }
              {
                name = "qwant";
                disabled = true;
              }
              {
                name = "startpage";
                disabled = true;
              }
              {
                name = "wlby";
                disabled = true;
              }
              {
                name = "yahoo";
                disabled = false;
              }
              {
                name = "yandex";
                disabled = true;
              }
              {
                name = "ddg definitions";
                disabled = false;
              }
              {
                name = "currency";
                disabled = true;
              }
              {
                name = "alexendria";
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
                disabled = false;
              }
              {
                name = "pinterest";
                disabled = true;
              }
              {
                name = "yandex images";
                disabled = false;
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
                categories = [
                  "science"
                  "article"
                ];
              }
              {
                name = "pubmed";
                categories = [
                  "science"
                  "article"
                ];
              }
              {
                name = "arxiv";
                categories = [
                  "science"
                  "article"
                ];
              }
            ];

            hostnames = {
              # replace = { "(.*.)?reddit.com" = "redlib.home"; };

              remove = [
                "(.*.)?facebook.com$"
                "(.*.)?instagram.com$"
                "(.*.)?medium.com$"
                "(.*.)?emacsdocs.org"
                "(.*.)?geeksforgeeks.org"
                "(.*.)?linkedin.com$"
                "(.*.)?researchgate.net"
                "(.*.)?kaggle.com$"
                "(.*.)?pintrest.com$"
                "(.*.)?twitter.com$"
                "(.*.)?x.com$"
                "(.*.)?wikihow.com$"
                "(.*.)?programiz.com$"
                "(.*.)?grokipedia.com$"
                "(.*.)?howtogeek.com$"
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
