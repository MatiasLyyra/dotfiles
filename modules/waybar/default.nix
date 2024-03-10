{ config, pkgs, lib, ... }:
let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar = {
    enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ pavucontrol ];
    programs.waybar = {
      enable = true;
      style = ''
        ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

        window#waybar {
          background: transparent;
          border-bottom: none;
        }
      '';

      settings = [
        {
          height = 30;
          layer = "top";
          position = "top";
          tray = { spacing = 10; };
          modules-center = [ "hyprland/window" ];
          modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "temperature"
            "clock"
            "tray"
          ];
          clock = {
            format-alt = "{:%Y-%m-%d}";
            tooltip-format = "{:%Y-%m-%d | %H:%M}";
          };
          cpu = { format = "{usage}% "; };
          memory = { format = "{}% 󰍛"; };
          network = {
            interval = 1;
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected ⚠";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈁 {bandwidthUpBits}  {bandwidthDownBits} ";
            format-linked = "{ifname} (No IP) 󰈂";
            format-wifi = "{essid} {signalStrength}% 󰘊";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              headphones = "󰋋";
              headset = "󰋎";
              phone = "";
              portable = "";
            };
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            on-click = "pavucontrol";
          };
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}󰔄 {icon}";
          }; 
        }
      ];
    };
  };
}
