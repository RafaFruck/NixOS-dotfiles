{...}: {
  flake.nixosModules.zsh = {config, ...}: {
    home-manager.users."rafafruck" = {pkgs, ...}: {
      home.file."zsh-scripts".source = ./zsh-scripts;
    };
  };
}
