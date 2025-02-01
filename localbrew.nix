{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall"; # uninstall unused formulae
      autoUpdate = true; # enable auto-updates
      upgrade = true; # enable formulae upgrades
    };

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
      "awscli"
      "humanlogio/tap/humanlog"
      "libiconv"
      "pinentry-mac"
      "filosottile/musl-cross/musl-cross"
      "zsh" # on my work mac without this jetbrains stuff is unhappy
    ];

    casks = [
      "brave-browser"
      "discord"
      "dropbox"
      "font-mona-sans"
      "font-monaspace"
      "font-sf-pro"
      "ghostty"
      "github"
      "inkscape"
      "ledger-live"
      "macfuse"
      "neohtop"
      "orbstack"
      "orion"
      "proton-drive"
      "proton-mail"
      "protonvpn"
      "rectangle"
      "signal"
      "skype"
      "tailscale"
      "telegram-desktop"
      "tuple"
      "utm"
      "visual-studio-code"
      "vlc"
      "wezterm"
      "whatsapp"
      "wireshark"
      "youtube-music"
      "yubico-authenticator"
      "yubico-yubikey-manager"
    ];
  };
}
