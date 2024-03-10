{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../system
  ];

  config.modules = {
    nvidia.enable = true;
  };
}