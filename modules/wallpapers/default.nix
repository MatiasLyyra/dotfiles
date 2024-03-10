{ pkgs, lib, stdenv, ... }:
let 
  wallpapers = {
    firewatch-day = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/k9/wallhaven-k9k3r1.jpg";
      sha256 = "sha256:1cm5fqljwrlmgy0md287j10m2y9gcjklymmwcfslgl9klzj5mvpq";
    };
    firewatch-evening = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/nk/wallhaven-nkm5gd.jpg";
      sha256 = "sha256:08x15xq9zic3hs7na9l4knxkx2cg1fj7wlwbpcz1zlpfw5ygc4rc";
    };
    firewatch-night = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/x1/wallhaven-x1kpl3.jpg";
      sha256 = "sha256:0fpspl8g911a62f8y2wdj37sd72ijbxvy10ncc6772zhc75mgv0v";
    };
    firewatch-rain = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/xl/wallhaven-xl3rll.jpg";
      sha256 = "sha256:0jb3nwh7792fn82whsw7lmvdsx3xpxxaip8gwyihkzh1igkjzcid";
    };
  };
in
{
  options.modules.wallpapers = {
    firewatch-day = lib.mkOption {
      readOnly = true;
      default = wallpapers.firewatch-day;
    };
    firewatch-evening = lib.mkOption {
      readOnly = true;
      default = wallpapers.firewatch-evening;
    };
    firewatch-night = lib.mkOption {
      readOnly = true;
      default = wallpapers.firewatch-night;
    };
    firewatch-rain = lib.mkOption {
      readOnly = true;
      default = wallpapers.firewatch-rain;
    };
  };
}
