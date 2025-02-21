{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # C/C++ Utils
    stm32cubemx
    binutils
    gcc
    clang-tools
    libgcc
    glibc
    glibc_multi
    bear

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
    uv

    # Assembly
    asm-lsp

    # Java Utils (Minecraft)
    (pkgs.jdk.override { enableJavaFX = true; })

    # Embedded
    arduino-ide
    arduino-cli
    esptool
    arduino-language-server

    # Virtual Machine
    qemu
    gcc-arm-embedded

    # RE and Bx
    ghidra-bin

    # General Required Programs
    kitty
    zsh
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
    mpv
    ddcutil
    i2c-tools
    tree
    powerline-fonts
    docker
    docker-compose
    ripgrep
    file

    # Gaming
    steam
    protonup

    # Screen Capture
    grim
    slurp
    imagemagick
    swappy
    wf-recorder
    tigervnc

  ];

}
