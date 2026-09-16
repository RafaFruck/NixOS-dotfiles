{globalColors, ...}: {
  flake.nixosModules.niri = {
    config,
    pkgs,
    pkgs-stable,
    ...
  }: {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    networking.networkmanager.enable = true;

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      #package = pkgs-stable.niri;
    };

    home-manager.users."rafafruck" = {
      pkgs,
      inputs,
      lib,
      ...
    }: {
      imports = [
        inputs.niri.homeModules.niri
      ];

      programs.niri = {
        enable = true;
        package = pkgs-stable.niri;
      };

      xdg.configFile."niri/config.kdl".source = ./config.kdl;

      home.file.".config/niri/colors.kdl".text = ''
        layout {
            set-variable "bg" "${globalColors.bg}"
            set-variable "fg" "${globalColors.fg}"
            set-variable "cursor" "${globalColors.cursor}"
            set-variable "selection_bg" "${globalColors.selection_bg}"

            set-variable "color0" "${globalColors.color0}"
            set-variable "color1" "${globalColors.color1}"
            set-variable "color2" "${globalColors.color2}"
            set-variable "color3" "${globalColors.color3}"
            set-variable "color4" "${globalColors.color4}"
            set-variable "color5" "${globalColors.color5}"
            set-variable "color6" "${globalColors.color6}"
            set-variable "color7" "${globalColors.color7}"
            set-variable "color8" "${globalColors.color8}"
            set-variable "color9" "${globalColors.color9}"
            set-variable "color10" "${globalColors.color10}"
            set-variable "color11" "${globalColors.color11}"
            set-variable "color12" "${globalColors.color12}"
            set-variable "color13" "${globalColors.color13}"
            set-variable "color14" "${globalColors.color14}"
            set-variable "color15" "${globalColors.color15}"
            set-variable "color16" "${globalColors.color16}"
            set-variable "color17" "${globalColors.color17}"
        }
      '';

      systemd.user.services.xwayland-satellite = {
        Unit = {
          Description = "Xwayland-satellite para aplicativos X11";
          Requires = ["niri.service"];
          After = ["niri.service"];
        };
        Service = {
          ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = ["niri.service"];
        };
      };
    };
  };
}
