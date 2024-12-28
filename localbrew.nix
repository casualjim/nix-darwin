{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";

    taps = [
      "bufbuild/buf"
      "felixkratz/formulae"
      "filosottile/musl-cross"
      "golangci/tap"
      "goreleaser/tap"
      "humanlogio/tap"
      "kyoh86/tap"
      "netbirdio/tap"
      "temporalio/brew"
      "th-ch/youtube-music"
      "yoheimuta/protolint"
    ];
    brews = [
      "humanlogio/tap/humanlog"
    ];
    casks = [
      "appflowy"
      "brave-browser"
      "discord"
      "dropbox"
      "font-mona-sans"
      "font-monaspace"
      "ghostty"
      "inkscape"
      "ledger-live"
      "macfuse"
      "neohtop"
      "netbird-ui"
      "signal"
      "skype"
      "telegram-desktop"
      "tuple"
      "utm"
      "visual-studio-code"
      "wezterm"
      "whatsapp"
      "youtube-music"
      "yubico-authenticator"
      "yubico-yubikey-manager"
    ];
  };
}
