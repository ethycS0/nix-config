{

  description = "Nixos config flake";

  inputs = {

    # Nix Packages Unstable Branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Xremap
    xremap-flake.url = "github:xremap/nix-flake";

    # NixVim
    nixvim.url = "github:ethycS0/nixvim-config";

    # Asus
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      homeConfigurations."arjun" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/home-manager/home.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga402
        ];
      };

      nixosConfigurations."arjun" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/nixos/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

    };
}
