{ pkgs, ... }:

{
  home.packages = [ pkgs.udiskie ];
  services.udiskie = {
    enable = true;
    notify = false;
  };
}
