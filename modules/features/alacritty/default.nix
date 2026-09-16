{ inputs , ... }: {

  flake.nixosModules.alacritty = { config, ... }: {
    
    home-manager.users."rafafruck" = { pkgs, ... }: {
      
      home.file.".config/alacritty/alacritty.toml".text = builtins.readFile ./alacritty.toml;
    };
  };
}
