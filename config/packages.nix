{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    powertop
    home-manager
    codeium
    lact
    mesa
    mesa-demos
    nextdns
    libva
    libva-utils
    vaapiVdpau
    vdpauinfo
  ];
}
