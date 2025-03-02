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
    inputs.home-manager.nixosModules.default
    inputs.xremap-flake.nixosModules.default
  ];

  # Environment
  environment = {

    # NixVim config
    systemPackages = [ inputs.nixvim.packages.${pkgs.system}.default ];

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.font-awesome_5
    ];
  };

  # Home Manager Setup
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "hm-backup";
    users = {
      "arjun" = import ../home-manager/home.nix;
    };
  };

  # Xremap Setup
  services.xremap = {
    userName = "arjun";
    yamlConfig = ''
      keymap:
        - name: main remaps
          remap:
            CapsLock: esc
            esc: CapsLock
    '';
  };

  # Syncthing Setup
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "arjun";
    dataDir = "/home/arjun/sync";
    configDir = "/home/arjun/.config/syncthing";
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      gui = {
        user = "arjun";
        password = "ethycS";
      };
    };
  };

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "robbyrussell";
    };
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
    };
  };

  # Asus Control
  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/arjun/docker/";
    };
  };

  # # Battery Saving
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
        scaling_min_freq = 400000;
        scaling_max_freq = 2200000;
      };

      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "auto";
        scaling_max_freq = 3201000;
      };

    };
  };
  system.stateVersion = "24.11";
}
