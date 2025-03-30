{

  description = "Nixos config flake";

  inputs = {

    # Nix Packages Unstable Branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Asus
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosConfigurations."arjun" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./config/configuration.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga402
          # (
          #   { config, pkgs, ... }:
          #   {
          #     boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./config/linux-g14.nix { });
          #   }
          # )
        ];
      };

    };
}
