{ inputs, lib, config, pkgs, ... }:
let
    cfg = config.modules.firefox;

in {
  options.modules.firefox = { enable = lib.mkEnableOption "firefox"; };
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # Privacy about:config settings
      profiles.notus = {
        settings = {
            "browser.send_pings" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "dom.event.clipboardevents.enabled" = true;
            "media.navigator.enabled" = false;
            "network.cookie.cookieBehavior" = 1;
            "network.http.referer.XOriginPolicy" = 2;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "beacon.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "network.IDN_show_punycode" = true;
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "app.shield.optoutstudies.enabled" = false;
            "geo.enabled" = false;

            # Disable telemetry
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.ping-centre.telemetry" = false;
            "browser.tabs.crashReporting.sendReport" = false;
            "devtools.onboarding.telemetry.logged" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.server" = "";

            # Disable Pocket
            "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "extensions.pocket.enabled" = false;

            # Disable prefetching
            "network.dns.disablePrefetch" = true;
            "network.prefetch-next" = false;

            # Disable JS in PDFs
            "pdfjs.enableScripting" = false;

            # Harden SSL 
            "security.ssl.require_safe_negotiation" = true;

            # Extra
            "identity.fxaccounts.enabled" = false;
            "browser.search.suggest.enabled" = false;
            "browser.urlbar.shortcuts.bookmarks" = false;
            "browser.urlbar.shortcuts.history" = false;
            "browser.urlbar.shortcuts.tabs" = false;
            "browser.urlbar.suggest.bookmark" = false;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.history" = false;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.topsites" = false;
            "browser.uidensity" = 1;
            "media.autoplay.enabled" = false;
            
            "privacy.firstparty.isolate" = true;
            "network.http.sendRefererHeader" = 0;
        };
      };
    };
  };
}
