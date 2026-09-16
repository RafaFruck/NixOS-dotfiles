{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.mySystemConfiguration = {
    config,
    pkgs,
    pkgs-stable,
    ...
  }: let
    sddm-astronaut-pkg = pkgs.sddm-astronaut.override {
      embeddedTheme = "black_hole";
    };
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    imports = [
      self.nixosModules.mySystemHardware
      self.nixosModules.niri
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.alacritty
      self.nixosModules.kitty
      self.nixosModules.zsh
      self.nixosModules.waybar
      self.nixosModules.hypr
      self.nixosModules.fuzzel
      inputs.self.nixosModules.nvim
      self.nixosModules.flatpak
      inputs.spicetify-nix.nixosModules.default
      self.nixosModules.jellyfin
    ];

    _module.args = {
      pkgs-stable = import inputs.nixpkgs-stable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };

    services.logind.settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader = {
      systemd-boot.enable = false;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;

        theme = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "retro-grub-theme";
          version = "1.0";

          src = pkgs.fetchFromGitHub {
            owner = "octavian451";
            repo = "retro_grub_theme";
            rev = "main";
            hash = "sha256-t4CMeTF5IS1weB6lkuZPExgNB2gYLkM9PlgSzvHdth0=";
          };
          installPhase = ''
                 mkdir -p $out
                 if [ -d "Retro_Grub" ]; then
            cp -r Retro_Grub/* $out/
                 elif [ -d "retro_grub" ]; then
            cp -r retro_grub/* $out/
                 else
            cp -r * $out/
                 fi
          '';
        });
      };
      efi.canTouchEfiVariables = true;
    };

    zramSwap.enable = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    networking.firewall.allowedTCPPorts = [22];

    services.tailscale.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.docker.enable = true;
    programs.virt-manager.enable = true;

    programs.nm-applet.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    time.timeZone = "America/Sao_Paulo";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = [
          pkgs.fcitx5-gtk
          pkgs.kdePackages.fcitx5-qt
          pkgs.qt6Packages.fcitx5-configtool
        ];
        waylandFrontend = true;
      };
    };

    services.displayManager.sddm = {
      enable = false;
      package = pkgs.kdePackages.sddm;
      wayland = {
        enable = true;
        compositor = "kwin";
      };

      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        sddm-astronaut-pkg
        kdePackages.qtmultimedia
      ];
      settings = {
        Theme.CursorTheme = "phinger-cursors-dark";
        General.GreeterEnvironment = "KWIN_FORCE_SW_CURSOR=1";
      };
    };

    services.displayManager.ly = {
      enable = true;
      settings = {
        animate = true;
        animation = 1;
        bigclock = true;
        clear_password = true;
      };
    };

    xdg.portal = {
      enable = true;
      config.common.default = ["gtk"];
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    services.xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      xkb.layout = "br";
      xkb.variant = "";
    };

    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = true;
    };

    console.keyMap = "br-abnt2";

    services.printing.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.power-profiles-daemon.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      gamescopeSession.steamArgs = ["-pipewire-dmabuf"];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.gamemode.enable = true;

    programs.zsh.enable = true;

    programs.starship = {
      enable = true;
      interactiveOnly = true;
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        glib
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs self;
        pkgs-stable = import inputs.nixpkgs-stable {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };
      backupFileExtension = "bak";
      users."rafafruck" = {
        home.username = "rafafruck";
        home.homeDirectory = "/home/rafafruck";
        home.stateVersion = "26.05";
        home.sessionPath = [
          "$HOME/.local/bin"
        ];

        imports = [
          inputs.spicetify-nix.homeManagerModules.default
        ];

        home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          package = pkgs.phinger-cursors;
          name = "phinger-cursors-dark";
          size = 24;
        };

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "adw-gtk3-dark";
          };
        };

        gtk = {
          enable = true;

          theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
          };

          font = {
            name = "JetBrainsMono Nerd Font";
            size = 11;
          };
        };

        qt = {
          enable = true;
          platformTheme.name = "gtk3";
          style.name = "adwaita-dark";
        };

        programs.firefox = {
          enable = true;
          profiles.rafafruck = {
            settings = {
              "font.name.monospace.x-western" = "JetBrains Mono Nerd Font";
              "font.name.sans-serif.x-western" = "JetBrains Mono Nerd Font";
              "font.name.serif.x-western" = "JetBrains Mono Nerd Font";
              "font.default.x-western" = "JetBrains Mono Nerd Font";
            };
          };
        };

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            font-name = "JetBrainsMono Nerd Font 11";
            document-font-name = "JetBrainsMono Nerd Font 11";
            monospace-font-name = "JetBrainsMono Nerd Font Monospace 11";
          };
        };

        home.packages = with pkgs; [
          vim
          wget
          git
          git-lfs
          kitty
          neovim
          xwayland-satellite
          alacritty
          fuzzel
          libnotify
          swaybg
          fetch
          cmatrix
          sl
          fortune
          cowsay
          eza
          obsidian
          cava
          brightnessctl
          file
          psmisc
          thunar-archive-plugin
          pavucontrol
          awww
          waybar
          yazi
          ripgrep
          hyprlock
          spotify-player
          gnome-disk-utility
          btop
          intel-gpu-tools
          mangohud
          protonup-ng
          arduino-cli
          arduino-language-server
          jq
          playerctl
          zathura
          pkgs-stable.texliveFull
          xclicker
          y-cruncher
          exfat
          veracrypt
          gparted
          parted
          tty-clock
          qalculate-gtk
          libqalculate
          spotify-cli-linux
          ibus
          bat
          fastfetch
          uv
          quickshell
          jellyfin-desktop
        ];

        programs.gh = {
          enable = true;
          settings = {
            git_protocol = "ssh";
          };
        };

        programs.spicetify = {
          enable = true;

          enabledCustomApps = with spicePkgs.apps; [
            marketplace
            lyricsPlus
          ];

          theme = spicePkgs.themes.text;
          colorScheme = "TokyoNight";

          enabledExtensions = with spicePkgs.extensions; [
            adblock
            shuffle
          ];
        };

        programs.obs-studio = {
          enable = true;
          plugins = [
            # If I wanted plugins
          ];
        };

        services.playerctld.enable = true;

        home.file.".config/bat/themes/tokyonight_night.tmTheme".source = "${pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "v3.0.1";
          hash = "sha256-QKqCsPxUyTur/zOUZdiT1cOMSotmTsnOl/3Sn2/NlUI=";
        }}/extras/sublime/tokyonight_night.tmTheme";

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
            SUDO_EDITOR = "nvim";
            TERM = "xterm-256color";
          };

          history = {
            size = 10000;
            path = "$HOME/.zsh_history";
          };

          shellAliases = {
            rebuild = "cd ~/.config/nixos-flake/ && git add . && sudo nixos-rebuild switch --flake .#mySystem && niri msg action load-config-file && cd -";
            ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
            ll = "eza --all --long --git --icons=always";
            tree = "eza --tree --icons=always";
            game-mode = "gamescope --steam -W 1920 -H 1080 -- steam -pipewire-dmabuf";
            clock = "tty-clock -scbB";
          };

          initContent = ''
            export PATH="$HOME/.local/bin:$PATH"

            _fzf_compgen_path() {
              fd --hidden --exclude .git . "$1"
            }
            _fzf_compgen_dir() {
              fd --type=d --hidden --exclude .git . "$1"
            }

            export UV_PYTHON_PREFERENCE=managed

            bindkey '^ ' forward-word
            bindkey '^[[27;5;9~' autosuggest-accept
          '';
        };

        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
          options = ["--cmd cd"];
        };

        programs.fzf = {
          enable = true;
          enableZshIntegration = true;
          defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
          changeDirWidget.command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
          historyWidget.options = [];
        };

        programs.starship = {
          enable = true;
          enableZshIntegration = true;

          settings = {
            add_newline = false;

            character = {
              success_symbol = "\\$(bold blue) [❯](bold green) ";
              error_symbol = "\\$(bold blue) [❯](bold red) ";
            };

            directory = {
              truncation_length = 3;
              truncate_to_repo = true;
              truncation_symbol = "…/";
            };
          };
        };

        home.sessionVariables = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
          GTK_CSD = "0";
          MAIN_SEPARATOR_DISABLE = "1";
          BAT_CONFIG_DIR = "$HOME/.config/bat";
          BAT_THEME = "tokyonight_night";
          FZF_CTRL_T = "fd --hidden --strip-cwd-prefix --exclude .git";
        };
      };
    };

    users.users."rafafruck" = {
      isNormalUser = true;
      description = "Rafael Fruck Dutra";
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "libvirtd"
        "docker"
        "video"
        "render"
      ];
      shell = pkgs.zsh;
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];
    programs.gamescope = {
      enable = true;
    };
    services.flatpak.enable = true;

    nixpkgs.config = {
      allowUnfree = true;
    };

    fonts.packages = [
      (builtins.path {
        name = "Fonts";
        path = ../../features/fonts/extracted;
      })
    ];

    environment.systemPackages = with pkgs; [
      sddm-astronaut-pkg
      phinger-cursors
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font"];
        sansSerif = ["JetBrainsMono Nerd Font"];
        serif = ["JetBrainsMono Nerd Font"];
      };
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
      libva-vdpau-driver
      vulkan-loader
      vulkan-validation-layers
    ];

    security.wrappers.intel_gpu_top = {
      owner = "root";
      group = "root";
      capabilities = "cap_perfmon+ep";
      source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
    };

    systemd.user.services.battery-monitor = {
      description = "Custom Niri Battery Monitor";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];

      script = ''
        NOTIFIED_5=false

        while true; do
          if [ -d /sys/class/power_supply/BAT0 ]; then
            BAT_CAP=$(cat /sys/class/power_supply/BAT0/capacity)
            BAT_STAT=$(cat /sys/class/power_supply/BAT0/status)

            if [ "$BAT_STAT" = "Discharging" ]; then

              # 1% Trigger: Critical popup and suspend after 3 seconds
              if [ "$BAT_CAP" -le 1 ]; then
                ${pkgs.libnotify}/bin/notify-send -u critical -t 3000 "CRITICAL BATTERY" "Connect charger! Suspending in 3 seconds..."
                sleep 3

                # Double-check status: if still discharging, suspend
                if [ "$(cat /sys/class/power_supply/BAT0/status)" = "Discharging" ]; then
                  systemctl suspend
                fi

              # 5% Trigger: Notify once
              elif [ "$BAT_CAP" -le 5 ]; then
                if [ "$NOTIFIED_5" = false ]; then
                  ${pkgs.libnotify}/bin/notify-send -u critical "Low Battery" "Battery dropped to 5%. Plug in your charger."
                  NOTIFIED_5=true
                fi
              fi

            else
              # Reset the 5% notification flag if the charger is plugged in
              NOTIFIED_5=false
            fi
          fi
          sleep 10
        done
      '';
    };

    system.stateVersion = "26.05";
  };
}
