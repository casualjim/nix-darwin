{
  description = "My nix-darwin flake";

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
      commonConfiguration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.autoconf
            pkgs.automake
            pkgs.bun
            pkgs.cmake
            pkgs.coreutils
            pkgs.curl
            pkgs.enchant
            pkgs.gcc
            pkgs.git
            pkgs.gnumake
            pkgs.gnused
            pkgs.gnutar
            pkgs.jq
            pkgs.libtool
            pkgs.libiconv
            pkgs.nasm
            pkgs.neovim
            pkgs.nodejs_20
            pkgs.time
            pkgs.uv
            pkgs.zsh
            pkgs.logdy
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "ivan"
          ];

          home-manager.backupFileExtension = "backup";
        };

      darwinConfiguration =
        { pkgs, ... }:
        {
          security.pam.enableSudoTouchIdAuth = true;
          system.stateVersion = 5;
          nixpkgs.hostPlatform = "aarch64-darwin";

          imports = [
            ./localbrew.nix
            ./darwin-env.nix
          ];

          programs.zsh.enable = true;

          users.users.ivan = {
            name = "ivan";
            home = "/Users/ivan";
          };

          system.defaults = {
            NSGlobalDomain = {
              AppleFontSmoothing = 0;
            };
          };

          environment.systemPackages = with pkgs; [
            darwin.apple_sdk.frameworks.CoreServices
            darwin.apple_sdk.frameworks.CoreFoundation
            darwin.apple_sdk.frameworks.Security
            darwin.apple_sdk.frameworks.SystemConfiguration
          ];

        };

      linuxConfiguration =
        { pkgs, ... }:
        {
          system.stateVersion = "24.11";
          nixpkgs.hostPlatform = "x86_64-linux";
          users.users.ivan = {
            name = "ivan";
            home = "/home/ivan";
          };
        };

      homeconfig =
        {
          hostname ? "descartes",
          username ? "ivan",
          isDarwin ? true,
        }:
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          home.stateVersion = "24.11";
          programs.home-manager.enable = true;
          programs.fastfetch.enable = true;
          imports = [
            (import ./zsh-config.nix {
              inherit hostname username;
            })
            ./bat-config.nix
          ];
          programs.starship = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
          };
          home.packages =
            with pkgs;
            [
              act
              bat
              btop
              cargo-binstall
              cargo-nextest
              coreutils
              curlie
              delta
              difftastic
              diffutils
              direnv
              dive
              docker-buildx
              eza
              fastfetch
              fd
              ffmpeg
              flyctl
              fswatch
              fzf
              gcc
              gh
              git
              git-lfs
              glow
              go
              gocryptfs
              go-mockery
              grc
              grpcui
              grpcurl
              gum
              hub
              httpie
              hyperfine
              jq
              just
              mise
              mkcert
              mods
              ngrep
              nil
              nixfmt-rfc-style
              opencv
              parallel
              pigz
              pkg-config
              prettyping
              pv
              pwgen
              ripgrep
              runpodctl
              rustup
              sccache
              starship
              temporal-cli
              tokei
              upx
              websocat
              xh
            ]
            ++ (
              if hostname == "archimedes" then
                with pkgs;
                [
                  golint
                  gofumpt
                  golangci-lint
                  gopls
                  goreleaser
                  gotestsum
                  gotestfmt
                  gotestdox
                  gotools
                  govulncheck
                  pyenv
                  shellcheck
                  shfmt
                  # Add other archimedes-specific packages here
                ]
              else
                [ ]
            );

          home.sessionPath = [
            "${config.home.homeDirectory}/.kube/bin"
            "${config.home.homeDirectory}/go/bin"
            "/opt/homebrew/bin"
            "/opt/homebrew/sbin"
          ];
          home.sessionVariables = {
            COLORTERM = "truecolor";
            TERM = "xterm-256color";
            JAVA_OPTS = "-Dfile.encoding=UTF-8";
            GRC_ALIASES = "true";
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

          home.file =
            {
              ".config/btop" = {
                source = ./config/btop;
                recursive = true;
              };
              ".config/starship.toml".source = ./config/starship.toml;
            }
            // (
              if isDarwin then
                {
                  ".config/wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
                  "Library/Application Support/com.mitchellh.ghostty/config".source = ./config/ghostty/config;
                }
              else
                { }
            );
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake '.#descartes'
      darwinConfigurations."descartes" = nix-darwin.lib.darwinSystem {
        modules = [
          commonConfiguration
          darwinConfiguration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.ivan = homeconfig {
              hostname = "descartes";
              username = "ivan";
            };
          }
        ];
      };

      darwinConfigurations."archimedes" = nix-darwin.lib.darwinSystem {
        modules = [
          commonConfiguration
          darwinConfiguration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.ivan = homeconfig {
              hostname = "archimedes";
              username = "ivan";
            };
          }
        ];
      };

      homeConfigurations = {
        ivan = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              home = {
                username = "ivan";
                homeDirectory = "/home/ivan";
                stateVersion = "24.11";
              };
            }
            (homeconfig {
              hostname = "sysiphus";
              username = "ivan";
              isDarwin = false;
            })
          ];
        };
      };
    };
}
