{ pkgs, config, lib, ... }:
let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    };
    home.packages = with pkgs; [
      hyprland wofi swaybg wlsunset wl-clipboard wlr-randr waybar kitty pipewire wireplumber
      mako
    ];
    modules.wofi.enable = true;

    home.file."~/.config/kitty/open-actions.conf".text = ''
      protocol file
      action launch --hold --type os-window xdg-open $FILE_PATH
    '';
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "swaybg -i ${config.modules.wallpapers.firewatch-day}"
        "mako"
        "exec-once=wlr-randr --output HDMI-A-1 --off && sleep 1 && wlr-randr --output HDMI-A-1 --on --pos 1920,0"
      ];
    };
    wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.conf;
  };
}
