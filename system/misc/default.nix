{ lib, config, pkgs, ... }:
{
  config = {
    # Boot loader
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
    boot.plymouth.enable = true;
    boot.plymouth.theme="breeze";
  
    # General
    environment.defaultPackages = [];
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
    ];
    programs.zsh.enable = true;
    programs.thunar.enable = true;
    programs.xfconf.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
    nix = {
      settings.auto-optimise-store = true;
      settings.allowed-users = [ "malyy" ];
      settings.experimental-features = [ "nix-command" "flakes" ];
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      }; 
    };
  
    # Video
    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    modules.sddm-kustom.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  
    # Sound
    sound = {
      enable = true;
    };
    hardware.pulseaudio.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  
    # Networking
    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [  ];
        allowedUDPPorts = [  ];
      };
    };
  
    # Vars
    environment.variables = {
      NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
      NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
      XDG_DATA_HOME = "$HOME/.local/share";
      EDITOR = "vim";
    };
  
    # User
    users.users.malyy = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
    security.sudo.enable = true;
    security.sudo.extraRules = [
      {
        users = [ "malyy" ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  
    # Localization
    time.timeZone = "Europe/Helsinki";
    time.hardwareClockInLocalTime = true;
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TELEPHONE = "fi_FI.UTF-8";
      LC_TUNE = "fi_FI.UTF-8";
    };
  
    fonts = {
      packages = with pkgs; [
        fira-code
        roboto
        ubuntu_font_family
        openmoji-color
        noto-fonts-emoji
        font-awesome
        (nerdfonts.override { fonts = [ "FiraCode" "Ubuntu" ]; })
      ];
  
      fontconfig = {
        defaultFonts = {
          serif = [ "Ubuntu" ];
          sansSerif = [ "Ubuntu" ];
          monospace = [ "FiraCode" ];
          emoji = [ "OpenMoji Color" ];
        };
        hinting.autohint = true;
      };
    };
    console = {
      font = "FiraCode";
      keyMap = "fi";
    };
  };
}
