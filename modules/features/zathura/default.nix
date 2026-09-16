{...}: {
  flake.nixosModules.zathura = {
    config,
    pkgs,
    ...
  }: {
    home-manager.users."rafafruck" = {...}: {
      home.file.".config/zathura/zathurarc".source = ./zathurarc;
    };
  };
}
