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

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Xremap
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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
