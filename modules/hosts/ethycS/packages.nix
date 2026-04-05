{ self, inputs, ... }:

{

  flake.nixosModules.ethycS-packages =

    { inputs, pkgs, ... }:

    {
      environment.systemPackages = with pkgs; [
        sddm-astronaut
        linux-firmware
        powertop
        home-manager
        codeium
        mesa
        mesa-demos
        nextdns
        libva
        libva-utils
        libva-vdpau-driver
        vdpauinfo
        btrfs-progs
        borgbackup
      ];
    };
}
