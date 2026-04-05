{

  description = "Nixos config flake";

  inputs = {

    # Nix Packages Unstable Branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Asus
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Wrapper Modules
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Flake Parts
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Import Tree
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
