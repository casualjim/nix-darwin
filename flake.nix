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

          imports = [ ./localbrew.nix ];

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

          imports = [
            ./zsh-config.nix
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

          home.file.".config/btop" = {
            source = ./config/btop;
            recursive = true;
          };
          home.file.".config/starship.toml".source = ./config/starship.toml;
          home.file.".config/wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
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
