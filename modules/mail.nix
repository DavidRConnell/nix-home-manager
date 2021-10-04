{ config, pkgs, lib, ... }: {
  home.packages = (with pkgs; [
    isync
    mu
    msmtp
  ]);
}
