{ name, subdomain ? name, users, port, ipAddress }: {
  containers."${subdomain}" = {
    autoStart = true;
    ephemeral = true;

    bindMounts = {
      "/var/lib/private/${name}" = {
        hostPath = "/data/${subdomain}";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      users = users;

      services.adguardhome = {
        enable = true;
        mutableSettings = false;
        settings = {
          bind_host = ipAddress;
          bind_port = port;
          users = [{
            name = "voidee";
            password =
              "$2a$10$Hoxzo9u2FMDGtHXMzDwLSO16FS1HZZ4GkldmH1F71ZSiihsk6E.HG";
          }];
          dns = {
            bind_hosts = [ "0.0.0.0" ];
            port = 53;
            bootstrap_dns =
              [ "9.9.9.10" "149.112.112.10" "2620:fe::10" "2620:fe::fe:10" ];
            upstream_dns = [
              "https://dns10.quad9.net/dns-query"
              "tls://1.1.1.1:853"
              "tls://1.0.0.1:853"
              "https://dns.switch.ch/dns-query"
              "https://unfiltered.adguard-dns.com/dns-query"
              "tls://dns.switch.ch"
              "tls://dns10.quad9.net"
            ];
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

      system.stateVersion = "22.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 53 80 port ];
        allowedUDPPorts = [ 53 ];
      };

      # Manually configure nameserver. Using resolved inside the container seems to fail
      # currently
      environment.etc."resolv.conf".text = "nameserver 9.9.9.9";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
