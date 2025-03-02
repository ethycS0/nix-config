{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Gnome Shit
    gnome-tweaks
    gnome-shell
    gnome-extension-manager
    auto-cpufreq

    # C/C++ Utils
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
    zsh
    firefox
    git
    tmux
    syncthing
    unzip
    zathura
    openssh
    discord
    obsidian
    wl-clipboard
    mpv
    tree
    powerline-fonts
    docker
    ripgrep
    file

    # Gaming
    steam
    protonup
    steam-run

    # Core
    pciutils
    usbutils
  ];

}
