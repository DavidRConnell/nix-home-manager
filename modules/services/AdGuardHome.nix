{ name, subdomain ? name, users, uid, port, hostAddress, localAddress }:
let unboundPort = 5353;
in {
  containers."${subdomain}" = {
    inherit hostAddress localAddress;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    bindMounts = {
      "/var/lib/private/${name}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
      "/var/lib/unbound" = {
        hostPath = "/data/unbound";
        isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = 53;
        hostPort = 53;
        protocol = "tcp";
      }
      {
        containerPort = 53;
        hostPort = 53;
        protocol = "udp";
      }
    ];

    config = { config, pkgs, ... }: {
      inherit users;

      environment = { systemPackages = with pkgs; [ dig ]; };

      services.adguardhome = {
        enable = true;
        mutableSettings = false;
        settings = {
          bind_host = localAddress;
          bind_port = port;
          users = [{
            name = "voidee";
            password =
              "$2a$10$Hoxzo9u2FMDGtHXMzDwLSO16FS1HZZ4GkldmH1F71ZSiihsk6E.HG";
          }];
          statistics = {
            enabled = true;
            interval = "168h";
          };
          dns = {
            bind_hosts = [ "0.0.0.0" ];
            port = 53;
            bootstrap_dns = [ "127.0.0.1:${(builtins.toString unboundPort)}" ];
            upstream_dns = [ "127.0.0.1:${(builtins.toString unboundPort)}" ];
            rewrites = [
              {
                domain = "routerlogin.net";
                answer = "192.168.0.1";
              }
              {
                domain = "*.home";
                answer = "192.168.0.101";
              }
              {
                domain = "*.test";
                answer = "192.168.0.100";
              }
            ];
            blocked_services = [
              "tiktok"
              "instagram"
              "twitch"
              "pinterest"
              "facebook"
              "vk"
              "zhihu"
              "ok"
              "twitter"
            ];
          };
          filters = [
            {
              enabled = true;
              url =
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
              name = "AdGuard DNS filter";
              id = 1;
            }
            {
              enabled = true;
              url =
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_32.txt";
              name = "The NoTracking blocklist";
              id = 1671249892;
            }
            {
              enabled = true;
              url =
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
              name = "The Big List of Hacked Malware Web Sites";
              id = 1671249896;
            }
            {
              enabled = true;
              url =
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt";
              name = "Perflyst and Dandelion Sprout's Smart-TV Blocklist";
              id = 1671390993;
            }
            {
              enabled = true;
              url =
                "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt";
              name = "Dandelion Sprout's Actually Legitimate URL Shortener";
              id = 1684246773;
            }
            {
              enabled = true;
              url =
                "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs%20for%20uBo/clear_urls_uboified.txt";
              name = "Dandelion Sprout's ClearURLs for uBo";
              id = 1684246774;
            }
            {
              enabled = true;
              url = "https://www.i-dont-care-about-cookies.eu/abp/";
              name = "I don't care about cookies";
              id = 1684246775;
            }
            {
              enabled = true;
              url =
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt";
              name = "OISD Blocklist Big";
              id = 1684246776;
            }
          ];
        };
      };

      services.unbound = {
        enable = true;
        # Adguard user owns unbound but adguard is owned by random system user ^\_O_/^
        user = name;
        group = name;
        stateDir = "/var/lib/unbound";
        # Largely taken from https://docs.pi-hole.net/guides/dns/unbound/
        settings.server = {
          port = unboundPort;
          interface = [ "127.0.0.1" ];
          do-ip4 = true;
          do-ip6 = false;
          prefer-ip6 = false;
          do-udp = true;
          do-tcp = true;
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          edns-buffer-size = 1232;
          prefetch = true;
          num-threads = 1;
          logfile = "/var/lib/unbound/unbound.log";
          log-time-ascii = true;
          verbosity = 0;
          private-address = [
            "192.168.0.0/16"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "10.0.0.0/8"
            "fd00::/8"
            "fe80::/10"
          ];
        };
      };

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 53 80 port ];
        allowedUDPPorts = [ 53 ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
