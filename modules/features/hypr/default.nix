{ pkgs, ... }: {

  flake.nixosModules.hypr = { config, pkgs, ... }: {
    home-manager.users."rafafruck" = { ... }: {
      
      home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;

    };
  };
}
