{ pkgs, lib, config, ... }:

let cfg = config.modules.xdg;
in {
  options.modules.xdg = { enable = lib.mkEnableOption "xdg"; };
  config = lib.mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
      documents = "$HOME/stuff/other/";
      download = "$HOME/stuff/other/";
      videos = "$HOME/stuff/other/";
      music = "$HOME/stuff/music/";
      pictures = "$HOME/stuff/pictures/";
      desktop = "$HOME/stuff/other/";
      publicShare = "$HOME/stuff/other/";
      templates = "$HOME/stuff/other/";
    };
  };
}
