flake-overlays:

{ config, pkgs, options, lib, ... }:
{
  nixpkgs.overlays = flake-overlays;
}
