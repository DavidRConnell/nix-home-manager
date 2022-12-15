{ ... }:

{
  services.nextdns = {
    enable = true;
    arguments = [ "-config" "41d196" "-cache-size=10MB" "-report-client-info" ];
  };
}
