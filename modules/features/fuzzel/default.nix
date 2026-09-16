{globalColors, ...}: {
  flake.nixosModules.fuzzel = {
    config,
    pkgs,
    ...
  }: {
    home-manager.users."rafafruck" = {...}: {
      home.file.".config/fuzzel/fuzzel.ini".source = ./fuzzel.ini;
      home.file.".config/fuzzel/colors.ini".text = ''
        [colors]
          background=${builtins.substring 1 6 globalColors.bg}cf   # Com 90% de opacidade (e6)
          text=${builtins.substring 1 6 globalColors.fg}ff
          match=${builtins.substring 1 6 globalColors.color4}ff  # Cor das letras que combinam na busca
          selection=${builtins.substring 1 6 globalColors.selection_bg}ff
          selection-text=${builtins.substring 1 6 globalColors.fg}ff
          selection-match=${builtins.substring 1 6 globalColors.color4}ff
          border=${builtins.substring 1 6 globalColors.color4}ff
      '';
    };
  };
}
