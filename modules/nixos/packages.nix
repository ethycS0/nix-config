{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # C/C++ Utils
    stm32cubemx
    binutils
    gcc
    clang-tools
    ccls
    libgcc

    # Lua Utils
    lua
    stylua

    # Nix Lang Utils
    nixfmt-rfc-style
    nil

    # Rust Utils
    cargo
    rust-analyzer
    rustfmt

    # Python Utils
    python3Full

    # Java Utils (Minecraft)
    (pkgs.jdk.override { enableJavaFX = true; })

    # Embedded
    arduino-ide
    arduino-cli
    esptool

    # General Required Programs
    kitty
    zsh
    neovim
    firefox
    git
    tmux
    rofi-wayland
    lf
    dolphin
    syncthing
    unzip
    openssh
    discord
    obsidian
    waybar
    dunst
    libnotify
    swww
    wl-clipboard
    neofetch
    cowsay
    mpv
    ddcutil
    i2c-tools
    tree
    powerline-fonts

    # Gaming
    steam
    mangohud
    protonup

    # Screen Capture
    grim
    slurp
    imagemagick
    swappy
    wf-recorder

  ];

}
