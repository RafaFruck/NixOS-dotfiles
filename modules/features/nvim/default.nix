{...}: {
  flake.nixosModules.nvim = {
    config,
    pkgs,
    ...
  }: {
    home-manager.users."rafafruck" = {...}: {
      xdg.configFile."nvim/init.lua".source = ./init.lua;
      xdg.configFile."nvim/lua/config/options.lua".source = ./options.lua;
      xdg.configFile."nvim/lua/config/keybinds.lua".source = ./keybinds.lua;
      xdg.configFile."nvim/lua/config/lazy.lua".source = ./lazy.lua;
      xdg.configFile."nvim/lua/plugins".source = ./lua/plugins;

      home.packages = with pkgs; [
        fd
        tree-sitter
        nil
        alejandra
        lua-language-server
        clang-tools
        rust-analyzer
        rustfmt
        basedpyright
        black
      ];
    };
  };
}
