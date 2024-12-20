{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # xhmm.url = "github:schuelermine/xhmm";
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.curl
            pkgs.devenv
            pkgs.git
            pkgs.jq
            pkgs.nixfmt-rfc-style
            pkgs.neovim
            pkgs.zsh
            pkgs.nil
            pkgs.direnv
            pkgs.fastfetch
            pkgs.coreutils
          ];

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

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "ivan"
          ];

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
          programs.zsh.enable = true;

          security.pam.enableSudoTouchIdAuth = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          # imports = [ ./modules/descartes.nix ];

          users.users.ivan = {
            name = "ivan";
            home = "/Users/ivan";
          };

          home-manager.backupFileExtension = "backup";
        };

      homeconfig =
        { pkgs, ... }:
        {
          # this is internal compatibility configuration
          # for home-manager, don't change this!
          home.stateVersion = "24.11";

          # Let home-manager install and manage itself.
          programs.home-manager.enable = true;
          programs.fastfetch.enable = true;

          programs.starship = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;

            settings = {
              palette = "catppuccin_mocha";

              character.success_symbol = "[[♥](green) ❯](maroon)";
              character.error_symbol = "[❯](red)";
              character.vimcmd_symbol = "[❮](green)";

              directory = {
                style = "bold lavender";
                read_only = " ";
                format = "\\[[$path]($style)[$read_only]($read_only_style)\\] ";
              };

              aws.format = "\\[[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style)\\]";
              bun.format = ''\[[$symbol($version)]($style)\]'';
              buf.format = ''\[[$symbol($version)]($style)\]'';
              c.format = ''\[[$symbol($version(-$name))]($style)\]'';
              cmake.format = ''\[[$symbol($version)]($style)\]'';
              cmd_duration.format = ''\[[⏱ $duration]($style)\]'';
              cobol.format = ''\[[$symbol($version)]($style)\]'';

              git_branch.format = ''\[[$symbol$branch]($style)\]'';

              palettes = {
                catppuccin_mocha = {
                  rosewater = "#f5e0dc";
                  flamingo = "#f2cdcd";
                  pink = "#f5c2e7";
                  mauve = "#cba6f7";
                  red = "#f38ba8";
                  maroon = "#eba0ac";
                  peach = "#fab387";
                  yellow = "#f9e2af";
                  green = "#a6e3a1";
                  teal = "#94e2d5";
                  sky = "#89dceb";
                  sapphire = "#74c7ec";
                  blue = "#89b4fa";
                  lavender = "#b4befe";
                  text = "#cdd6f4";
                  subtext1 = "#bac2de";
                  subtext0 = "#a6adc8";
                  overlay2 = "#9399b2";
                  overlay1 = "#7f849c";
                  overlay0 = "#6c7086";
                  surface2 = "#585b70";
                  surface1 = "#45475a";
                  surface0 = "#313244";
                  base = "#1e1e2e";
                  mantle = "#181825";
                  crust = "#11111b";
                };

                catppuccin_macchiato = {
                  rosewater = "#f4dbd6";
                  flamingo = "#f0c6c6";
                  pink = "#f5bde6";
                  mauve = "#c6a0f6";
                  red = "#ed8796";
                  maroon = "#ee99a0";
                  peach = "#f5a97f";
                  yellow = "#eed49f";
                  green = "#a6da95";
                  teal = "#8bd5ca";
                  sky = "#91d7e3";
                  sapphire = "#7dc4e4";
                  blue = "#8aadf4";
                  lavender = "#b7bdf8";
                  text = "#cad3f5";
                  subtext1 = "#b8c0e0";
                  subtext0 = "#a5adcb";
                  overlay2 = "#939ab7";
                  overlay1 = "#8087a2";
                  overlay0 = "#6e738d";
                  surface2 = "#5b6078";
                  surface1 = "#494d64";
                  surface0 = "#363a4f";
                  base = "#24273a";
                  mantle = "#1e2030";
                  crust = "#181926";
                };

                catppuccin_frappe = {
                  rosewater = "#f2d5cf";
                  flamingo = "#eebebe";
                  pink = "#f4b8e4";
                  mauve = "#ca9ee6";
                  red = "#e78284";
                  maroon = "#ea999c";
                  peach = "#ef9f76";
                  yellow = "#e5c890";
                  green = "#a6d189";
                  teal = "#81c8be";
                  sky = "#99d1db";
                  sapphire = "#85c1dc";
                  blue = "#8caaee";
                  lavender = "#babbf1";
                  text = "#c6d0f5";
                  subtext1 = "#b5bfe2";
                  subtext0 = "#a5adce";
                  overlay2 = "#949cbb";
                  overlay1 = "#838ba7";
                  overlay0 = "#737994";
                  surface2 = "#626880";
                  surface1 = "#51576d";
                  surface0 = "#414559";
                  base = "#303446";
                  mantle = "#292c3c";
                  crust = "#232634";
                };

                catppuccin_latte = {
                  rosewater = "#dc8a78";
                  flamingo = "#dd7878";
                  pink = "#ea76cb";
                  mauve = "#8839ef";
                  red = "#d20f39";
                  maroon = "#e64553";
                  peach = "#fe640b";
                  yellow = "#df8e1d";
                  green = "#40a02b";
                  teal = "#179299";
                  sky = "#04a5e5";
                  sapphire = "#209fb5";
                  blue = "#1e66f5";
                  lavender = "#7287fd";
                  text = "#4c4f69";
                  subtext1 = "#5c5f77";
                  subtext0 = "#6c6f85";
                  overlay2 = "#7c7f93";
                  overlay1 = "#8c8fa1";
                  overlay0 = "#9ca0b0";
                  surface2 = "#acb0be";
                  surface1 = "#bcc0cc";
                  surface0 = "#ccd0da";
                  base = "#eff1f5";
                  mantle = "#e6e9ef";
                  crust = "#dce0e8";
                };
              };
            };
          };

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            shellAliases = {
              l = "eza -lh --icons --git";
              ls = "eza --icons -G";
              lsa = "eza --icons -lah --git";
              ll = "eza --icons -lh --git";
              la = "eza --icons -lah --git";
              tree = "eza --tree --icons";
              vim = "nvim";
              ping = "prettyping --nolegend";
            };


            localVariables = {
              ZSH_CACHE_DIR="$HOME/Library/Caches/antidote";
            };

            initExtraBeforeCompInit = ''
              export ZSH_CACHE_DIR
              [[ ! -d $HOME/Library/Caches/antidote/completions ]] && mkdir -p $ZSH_CACHE_DIR/completions
            '';

            initExtra = ''
              cat() { bat --paging never --plain --plain "$@" }

              if [ $commands[direnv] ]; then
                eval "$(direnv hook zsh)"
              fi

              if [ $commands[hub] ]; then
                eval "$(hub alias -s)"
              fi
            '';

            envExtra = ''
              . "/etc/profiles/per-user/$USER/etc/profile.d/grc.sh"
              . "$HOME/.cargo/env"
            '';

            historySubstringSearch = {
              enable = true;
            };
            antidote = {
              enable = true;
              plugins = [
                "zsh-users/zsh-completions"
                "ohmyzsh/ohmyzsh path:lib"
                "ohmyzsh/ohmyzsh path:plugins/git"
                "ohmyzsh/ohmyzsh path:plugins/macos"
                "ohmyzsh/ohmyzsh path:plugins/cp"
                "ohmyzsh/ohmyzsh path:plugins/direnv"
                "ohmyzsh/ohmyzsh path:plugins/ripgrep kind:fpath"
                "ohmyzsh/ohmyzsh path:plugins/fd kind:fpath"
                "ohmyzsh/ohmyzsh path:plugins/fzf"
                "ohmyzsh/ohmyzsh path:plugins/mvn"
                "ohmyzsh/ohmyzsh path:plugins/python"
                "ohmyzsh/ohmyzsh path:plugins/pip"
                "ohmyzsh/ohmyzsh path:plugins/node"
                "ohmyzsh/ohmyzsh path:plugins/npm"
                "ohmyzsh/ohmyzsh path:plugins/golang"
                "ohmyzsh/ohmyzsh path:plugins/rust"
                "ohmyzsh/ohmyzsh path:plugins/aws"
                "ohmyzsh/ohmyzsh path:plugins/docker"
                "ohmyzsh/ohmyzsh path:plugins/docker-compose"
                "ohmyzsh/ohmyzsh path:plugins/kubectl"
                "ohmyzsh/ohmyzsh path:plugins/minikube"
                "ohmyzsh/ohmyzsh path:plugins/helm"
                "zdharma-continuum/fast-syntax-highlighting kind:defer"
                "zsh-users/zsh-history-substring-search"
                "belak/zsh-utils path:completion"
              ];
            };
          };

          programs.bat = {
            enable = true;
            config = {
              theme = "Catppuccin-mocha";
            };
            themes = {
              Catppuccin-mocha = {
                src = pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "bat";
                  rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
                  hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
                };
                file = "themes/Catppuccin Mocha.tmTheme";
              };
              Catppuccin-macchiato = {
                src = pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "bat";
                  rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
                  hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
                };
                file = "themes/Catppuccin Macchiato.tmTheme";
              };
              Catppuccin-latte = {
                src = pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "bat";
                  rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
                  hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
                };
                file = "themes/Catppuccin Latte.tmTheme";
              };
              Catppuccin-frappe = {
                src = pkgs.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "bat";
                  rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
                  hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
                };
                file = "themes/Catppuccin Frappe.tmTheme";
              };
            };
          };

          home.packages = with pkgs; [
            starship
            curlie
            btop
            bat
            eza
            fd
            ripgrep
            fzf
            gh
            git
            delta
            git-lfs
            hub
            difftastic
            grc
            prettyping
            xh
            gocryptfs
          ];

          home.sessionVariables = {
            COLORTERM = "truecolor";
            TERM = "xterm-256color";
            JAVA_OPTS = "-Dfile.encoding=UTF-8";
            GCC_COLORS = "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
            LANG = "en_US.utf-8";
            CLICOLOR = "1";
            EDITOR = "code -w";
            VISUAL = "code -w";
            GITHUB_USER = "casualjim";
            BAT_THEME = "Catppuccin-mocha";
            MANPAGER = "sh -c 'col -bx | bat -l man -p'";
            MANROFFOPT = "-c";
            FZF_DEFAULT_COMMAND = "fd --type file --color=always";
            FZF_DEFAULT_OPTS = "--ansi";
          };

          # home.file.".config/starship.toml".source = ./starship.toml;
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake '.#descartes'
      darwinConfigurations."descartes" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.ivan = homeconfig;
          }
        ];
      };

      darwinConfigurations."archimedes" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.ivan = homeconfig;
          }
        ];
      };
    };
}
