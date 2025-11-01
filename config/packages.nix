{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    linux-firmware
    powertop
    home-manager
    codeium
    lact
    mesa
    mesa-demos
    nextdns
    libva
    libva-utils
    libva-vdpau-driver
    vdpauinfo
    btrfs-progs
  ];
}
