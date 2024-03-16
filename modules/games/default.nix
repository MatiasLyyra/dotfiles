{ pkgs, lib, config, ... }:
let
  cfg = config.modules.games;
in {
  options.modules.games = {
    enable = lib.mkEnableOption "games";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      steam
      (pkgs.discord.override {
        withVencord = true;
      })
    ];
    home.file.".config/discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
  };
}
