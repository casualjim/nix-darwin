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
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "ivan"
          ];
          users.users.ivan = {
            name = "ivan";
            home = "/Users/ivan";
          };
        };

      darwinConfiguration =
        { pkgs, ... }:
        {
          security.pam.enableSudoTouchIdAuth = true;
          system.stateVersion = 5;
          nixpkgs.hostPlatform = "aarch64-darwin";
          imports = [ ./localbrew.nix ];
          programs.zsh.enable = true;
        };

      linuxConfiguration =
        { pkgs, ... }:
        {
          system.stateVersion = "24.11";
          nixpkgs.hostPlatform = "x86_64-linux";
        };

      homeconfig =
        {
          hostname ? "descartes",
          username ? "ivan",
          isDarwin ? true,
        }:
        { config, pkgs, ... }:
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
          home.sessionPath = [
            "${config.home.homeDirectory}/go/bin"
            "${config.home.homeDirectory}/.kube/bin"
            "/opt/homebrew/bin"
            "/opt/homebrew/sbin"
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

      nixosConfigurations."sysiphus" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          commonConfiguration
          linuxConfiguration
          home-manager.nixosModules.home-manager
          {
            home-manager.users.ivan = homeconfig {
              hostname = "sysiphus";
              username = "ivan";
              isDarwin = false;
            };
          }
        ];
      };
    };
}
