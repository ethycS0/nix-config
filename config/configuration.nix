{
  pkgs,
  lib,
  ...
}:

{
  # Import Other Configs
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Services
  services = {
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;

    # Udev
    udev = {
      enable = true;
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0666", GROUP="plugdev"
      '';

      packages = [
        (pkgs.writeTextFile {
          name = "stlink-udev-rules";
          destination = "/lib/udev/rules.d/49-stlink.rules";
          text = ''
            # STMicroelectronics ST-LINK access for non-root
            # Vendor ID 0483, common ST-LINK product IDs
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE:="0660", GROUP:="plugdev", TAG+="uaccess"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE:="0660", GROUP:="plugdev", TAG+="uaccess"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0660", GROUP:="plugdev", TAG+="uaccess"

            # Optional: ST-LINK/V3 common IDs (helpful if you use newer probes)
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE:="0660", GROUP:="plugdev", TAG+="uaccess"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE:="0660", GROUP:="plugdev", TAG+="uaccess"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE:="0660", GROUP:="plugdev", TAG+="uaccess"
          '';
        })

        (pkgs.writeTextFile {
          name = "esp-prog-udev-rules";
          destination = "/lib/udev/rules.d/49-esp-prog.rules";
          text = ''
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTR{idProduct}=="6010", MODE:="0666", GROUP:="plugdev", TAG+="uaccess"
          '';
        })
      ];
    };

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Graphics
      videoDrivers = [ "amdgpu" ];

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Asus Control
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };

    power-profiles-daemon.enable = true;

    # NextDNS
    nextdns = {
      enable = true;
      arguments = [
        "-config"
        "3d9bb9"
        "-cache-size"
        "10MB"
      ];
    };

    # Taskwarrior Host
    taskchampion-sync-server = {
      enable = true;
      host = "0.0.0.0";
      port = 8080;
    };

    immich = {
      enable = true;
      host = "0.0.0.0";
      port = 2283;
      openFirewall = true;
      mediaLocation = "/var/lib/immich";
    };

    tailscale.enable = true;
    resolved = {
      enable = true;
      settings.Resolve = {
        DNS = [
          "45.90.28.40#3d9bb9.dns.nextdns.io"
          "45.90.30.40#3d9bb9.dns.nextdns.io"
        ];
        DNSOverTLS = true;
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
    kernelParams = [ "usbcore.autosuspend=-1" ];

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
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = [
      "xhci_hcd"
      "ehci_hcd"
      "uhci_hcd"
      "usbhid"
    ];
  };

  # Enable networking
  networking = {
    hostName = "ethycS";
    networkmanager.enable = true;

    # Firewall
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [
        7400
        7401
        8888
      ];
    };

    nameservers = [
      "45.90.28.40"
      "45.90.30.40"
    ];
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

  # Groups
  users.groups = {
    plugdev = { };
    libvirtd.members = [ "ethycs" ];
  };

  # Users
  users.users = {
    ethycs = {
      isNormalUser = true;
      description = "ethycS";
      extraGroups = [
        "adbusers"
        "networkmanager"
        "wheel"
        "i2c"
        "syncthing"
        "docker"
        "plugdev"
        "dialout"
        "libvirtd"
      ];
      shell = pkgs.zsh;
    };

    immich.extraGroups = [
      "video"
      "render"
    ];
  };

  programs = {
    zsh.enable = true;
    virt-manager.enable = true;

    # Gaming Setup
    steam = {
      enable = true;
      gamescopeSession.enable = true;

    };
  };

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

  # Hardware
  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
    i2c.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        libva-vdpau-driver
        libvdpau-va-gl
      ];

    };
    uinput.enable = true;
  };

  environment.systemPackages = with pkgs; [ lact ];
  systemd = {
    packages = with pkgs; [ lact ];
    services = {
      lactd.wantedBy = [ "multi-user.target" ];
    };
  };

  # Battery Saving
  powerManagement.powertop.enable = true;

  # ... rest of your configuration
  system.stateVersion = "24.11";
}
