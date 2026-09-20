{...}: {
  flake.nixosModules.zsh = {
    config,
    pkgs,
    ...
  }: {
    programs.zsh.enable = true;

    programs.starship = {
      enable = true;
      interactiveOnly = true;
    };

    users.users."rafafruck".shell = pkgs.zsh;

    home-manager.users."rafafruck" = {pkgs, ...}: {
      home.file."zsh-scripts".source = ./zsh-scripts;

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
          rebuild = "cd ~/.config/nixos-flake/ && git add . && sudo nixos-rebuild switch --flake .#mySystem && git commit -m \"Gen: \$(readlink /nix/var/nix/profiles/system | cut -d- -f2)\" && niri msg action load-config-file && cd -";
          ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
          ll = "eza --all --long --git --icons=always";
          tree = "eza --tree --icons=always";
          game-mode = "gamescope --steam -W 1920 -H 1080 -- steam -pipewire-dmabuf";
          clock = "tty-clock -scbB";
          gpom = "git push origin main";
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

               gcp() {
          if [ -z "$1" ]; then
            echo "❌ Write a message!"
                   return 1
          fi
          git reset --soft origin/main && \
          git commit -m "$1" && \
          git push origin main
               }

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
}
