final: prev: {
  lib = prev.lib // {
    mkVHost = { subdomain, port, domain ? "home" }: {
      "${subdomain}.${domain}".locations."/".proxyPass =
        "http://127.0.0.1:${port}";
    };
  };
}
