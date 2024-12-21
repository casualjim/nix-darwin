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
    brews = [ ];
    casks = [
      "appflowy"
      "brave-browser"
      "discord"
      "docker"
      "dropbox"
      "font-cascadia-code"
      "font-cascadia-mono"
      "font-caskaydia-cove-nerd-font"
      "font-monaspace"
      "font-monaspace-nerd-font"
      "font-hack-nerd-font"
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
