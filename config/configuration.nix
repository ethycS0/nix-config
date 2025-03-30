{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  # Import Other Configs
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./kernel.nix
  ];

  # Environment
  environment = {
    # Environment Session Variables
    sessionVariables = {
      NIXOS_OZONE_WL = "1";

      # Minecraft
      LD_LIBRARY_PATH = lib.makeLibraryPath [
        pkgs.libglvnd
        pkgs.pulseaudio
      ];
    };

    # Environment Variables
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  # Services
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;

      # Graphics
      videoDrivers = [ "amdgpu" ];

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  # Flakes and other Experimental Features Setup
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        backgroundColor = "#000000";
        gfxmodeEfi = "2560x1600";
        gfxpayloadEfi = "keep";
        useOSProber = true;
        font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
        fontSize = 36;
        splashImage = null;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    initrd.luks.devices."luks-e495f34a-2b13-4312-99a0-9027820fb316".device =
      "/dev/disk/by-uuid/e495f34a-2b13-4312-99a0-9027820fb316";
    # kernelPackages = pkgs.linuxPackages_latest;
  };

  # Enable networking
  networking = {
    hostName = "ethycS";
    networkmanager.enable = true;

    # Firewall
    firewall = {
      enable = false;
      allowedUDPPorts = [
        7400
        7401
        8888
      ];
    };
  };

  # Time Zone.
  time.timeZone = "Asia/Kolkata";

  # Internationalisation Properties.
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Udev
  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0666", GROUP="plugdev"
    '';
  };

  # Groups
  users.groups = {
    plugdev = { };
  };

  # Users
  users.users.arjun = {
    isNormalUser = true;
    description = "Arjun Salunkhe";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "syncthing"
      "docker"
      "plugdev"
      "dialout"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.font-awesome_5
      pkgs.fira-code
    ];
  };

  # Gaming Setup
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

  };

  # Hardware
  hardware = {
    bluetooth.enable = true;
    i2c.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        vaapiVdpau
        libvdpau-va-gl
      ];

    };
    uinput.enable = true;
  };

  # Asus Control
  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  environment.systemPackages = with pkgs; [ lact ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/arjun/docker/";
    };
  };

  # Battery Saving
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;

  # NextDNS
  services.nextdns = {
    enable = true;
    arguments = [
      "-config"
      "3d9bb9"
      "-cache-size"
      "10MB"
    ];
  };

  system.stateVersion = "24.11";
}
