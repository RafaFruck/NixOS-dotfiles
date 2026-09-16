{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.mySystem = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.mySystemConfiguration
    ];
  };
}
