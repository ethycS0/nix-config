{
  config,
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

  boot.supportedFilesystems = ["fat32"];

  # Environment Session Variables
  environment.sessionVariables = {
    # If cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hine electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    # Proton for Steam
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    # Minecraft
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.libglvnd
      pkgs.pulseaudio
    ];
  };

  # Environment Variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Flakes and other Experimental Features Setup
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };
  boot.initrd.luks.devices."luks-df417708-4738-481a-a831-ffeadb4b9d6f".device =
    "/dev/disk/by-uuid/df417708-4738-481a-a831-ffeadb4b9d6f";

  # Enable networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  # Brightness Control
  hardware.i2c.enable = true;
  # services.ddccontrol.enable = true;

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

  # Hyprland Setup
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  # Xremap Setup
  services.xremap = {
    withHypr = true;
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
    dataDir = "/home/arjun/Sync";
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

  # Graphics
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.open = true;
    graphics.enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";

  };

  specialisation = {
    gaming.configuration = {
      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };

  # Gaming Setup
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

  };
  programs.gamemode.enable = true;
  hardware.xpadneo.enable = true;
  hardware.steam-hardware.enable = true;

  # Asus Control
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  # Others
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
