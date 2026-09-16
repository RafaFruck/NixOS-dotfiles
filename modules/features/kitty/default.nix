{...}: {
  flake.nixosModules.kitty = {config, ...}: {
    home-manager.users."rafafruck" = {pkgs, ...}: {
      home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
      home.file.".config/kitty/nvim.conf".source = ./nvim.conf;
    };
  };
}
