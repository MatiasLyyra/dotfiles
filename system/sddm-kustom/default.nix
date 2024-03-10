{ config, lib, pkgs, ... }:

let
  cfg = config.modules.sddm-kustom;
  buildTheme = { name, version, src, themeIni }:
    pkgs.stdenv.mkDerivation rec {
      pname = "sddm-theme-${name}";
      inherit version src;
      buildInputs = [
        pkgs.crudini
      ];
      buildPhase = ''
        buildDir=$PWD/build-${name}
        dir=$buildDir/share/sddm/themes/${name}
        doc=$buildDir/share/doc/${pname}

        mkdir -p $dir $doc
        if [ -d $src/${name} ]; then
          srcDir=$src/${name}
        else
          srcDir=$src
        fi

        cp -r $srcDir/* $dir/
        for f in $dir/{AUTHORS,COPYING,LICENSE,README,*.md,*.txt}; do
          test -f $f && mv $f $doc/
        done
        chmod 600 $dir/theme.conf
        ${lib.concatMapStringsSep "\n" (e: ''
          ${pkgs.crudini}/bin/crudini --set --inplace $dir/theme.conf \
            "${e.section}" "${e.key}" "${e.value}"
        '') themeIni}
      '';

      installPhase = ''
        installDir=$out/share/sddm/themes/
        installDoc=$out/share/doc/
        mkdir -p $installDir $intallDoc
        cp -r $dir $installDir
        cp -r $doc $installDoc
      '';
    };

  customTheme = lib.attrsets.hasAttrByPath [ cfg.theme ] themes;
  theme = if customTheme then lib.attrsets.attrByPath [ cfg.theme ] cfg.theme themes else cfg.theme;

  themeName = if customTheme
  then theme.pkg.name
  else theme;

  packages = if customTheme
  then [ (buildTheme theme.pkg) ] ++ theme.deps
  else [];

  themes = {
    sugar-dark = {
      pkg = rec {
        name = "sugar-dark";
        version = "1.2";
        src = pkgs.fetchFromGitHub {
          owner = "MarianArlt";
          repo = "sddm-${name}";
          rev = "v${version}";
          sha256 = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
        };
        themeIni = [
          {
            section = "Design Customizations";
            key = "Font";
            value = "Fira Code";
          }
          {
            section = "General";
            key = "ScreenWidth";
            value = "1920";
          }
          {
            section = "General";
            key = "ScreenHeight";
            value = "1080";
          }
          {
            section = "General";
            key = "Background";
            value = config.modules.wallpapers.firewatch-rain;
          }
        ];
      };
      deps = with pkgs; [ qt5.qtquickcontrols2 qt5.qtsvg qt5.qtgraphicaleffects ];
    };
  };
in
{
  options.modules.sddm-kustom = {
    enable = lib.mkEnableOption "sddm-kustom";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "sugar-dark";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = packages;
    services.xserver.displayManager.sddm.theme = themeName;
  };
}
