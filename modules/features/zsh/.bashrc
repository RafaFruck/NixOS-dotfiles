
####        Aliases

alias rebuild="cd /etc/nixos && git add . && sudo nixos-rebuild switch --flake .#mySystem && niri msg action load-config-file && cd -"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --all --long --git --icons=always"
alias tree="eza --tree --icons=always"
alias sudonvim="sudo -E nvim"
alias game-mode="gamescope --steam -W 1920 -H 1080 -- steam -pipewire-dmabuf"
alias clock="tty-clock -scbB"

####        Zoxide

eval "$(zoxide init bash)"
alias cd="z"

####        Fzf
eval "$(fzf --bash)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export BAT_THEME="tokyonight_night"
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

####       Exports

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export TERM=xterm-256color

####       Startup commands
