{ config, lib, pkgs, ... }:
let
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia = {
    enable = lib.mkEnableOption "nvidia";
  };
  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.libvdpau-va-gl ];
    };
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    environment.variables.VDPAU_DRIVER = "va_gl";
    environment.variables.LIBVA_DRIVER_NAME = "nvidia";
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
