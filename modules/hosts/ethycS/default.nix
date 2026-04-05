{ self, inputs, ... }:

{
  flake.nixosConfigurations.ethycS = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.ethycS-configuration
    ];
  };
}
