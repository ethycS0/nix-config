{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    powertop
    home-manager
    codeium
    lact
    mesa
    mesa-demos
    mesa.drivers
    libva
    libva-utils
    vaapiVdpau
    vdpauinfo
  ];
}
