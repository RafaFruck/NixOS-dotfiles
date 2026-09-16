{globalColors, ...}: {
  flake.nixosModules.waybar = {
    config,
    pkgs,
    ...
  }: {
    home-manager.users."rafafruck" = {...}: {
      home.file.".config/waybar/config.jsonc".source = ./config.jsonc;
      home.file.".config/waybar/style.css".source = ./style.css;
      home.file.".config/waybar/scripts/gpu.sh" = {
        source = ./gpu.sh;
        executable = true;
      };
      home.file.".config/waybar/global-colors.css".text = ''
        @define-color background ${globalColors.bg};
        @define-color foreground ${globalColors.fg};
        @define-color color0     ${globalColors.color0};
        @define-color color1     ${globalColors.color1};
        @define-color color2     ${globalColors.color2};
        @define-color color3     ${globalColors.color3};
        @define-color color4     ${globalColors.color4};
        @define-color color5     ${globalColors.color5};
        @define-color color6     ${globalColors.color6};
        @define-color color7     ${globalColors.color7};
      '';
    };
  };
}
