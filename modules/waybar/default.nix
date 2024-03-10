{ config, pkgs, lib, writeShellApplication, nixpkgs, ... }:
let
  cfg = config.modules.waybar;
  python3 = pkgs.python3.withPackages (ps: with ps; [ requests ]);
  weatherScript = pkgs.writeShellApplication {
    name = "weather";
    runtimeInputs = [
      python3
    ];
    text = ''
      python3 ${./scripts/weather.py}
    '';
  };
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
        ${builtins.readFile ./styles.css}
      '';

      settings = [
        {
          layer = "top";
          position = "top";
          modules-center = [ "clock" "custom/weather" ];
          modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
          modules-right = [
            "pulseaudio"
            "cpu"
            "memory"
            "temperature"
          ];
          clock = {
            format-alt = "{:%Y-%m-%d 󰃭 %H:%M }";
          };
          cpu = { format = "{usage}% "; };
          memory = { format = "{}% 󰍛"; };
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
          "custom/weather" = {
            format = "{}";
            tooltip =  true;
            interval = 1800;
            exec = "${weatherScript}/bin/weather";
            return-type = "json";
          };
        }
        {
          layer = "top";
          position = "bottom";
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "network"
          ];
          network = {
            interval = 1;
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected ⚠";
            format-ethernet = "{bandwidthUpBits}  {bandwidthDownBits}  {ifname}: {ipaddr}/{cidr} 󰈁";
            format-linked = "{ifname} (No IP) 󰈂";
            format-wifi = "{essid} {signalStrength}% 󰘊";
          };
        }
      ];
    };
  };
}
