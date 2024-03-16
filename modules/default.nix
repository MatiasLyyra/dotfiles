{ config, pkgs, ... }:
{
  imports = [
    ./wallpapers
    ./firefox
    ./hyprland
    ./waybar
    ./wofi
    ./xdg
    ./games
  ];

  config = {
    home.packages = with pkgs; [ htop gnupg bat eza ];

    programs.git = {
      enable = true;
      userName = "Matias Lyyra";
      userEmail = "matias.lyyra@gmail.com";
    };

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline ];
      extraConfig = ''
        filetype plugin indent on
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set number
      '';
    };

    programs.zsh = {
      enable = true;
      enableCompletion = false;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      
      dotDir = ".config/zsh";

      history = {
        save = 8000;
        size = 8000;
        path = "$HOME/.cache/zsh_history";
      };

      shellAliases = {
        ls = "eza --icons --hyperlink";
        tree = "eza --tree --icons --hyperlink";
      };

      dirHashes = {
        nixos = "$HOME/.config/nixos";
        src = "$HOME/src";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "awesomepanda";
      };
    };

    home.stateVersion = "23.11";
  };
}
