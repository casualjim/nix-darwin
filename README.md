# My Home Manager setup

This repo contains my configuration for nix-darwin and home-manager.  I'm very new to all of this so it may be more messy than it could be.

## Installation

I basically followed this guide: [https://davi.sh/til/nix/nix-macos-setup/](https://davi.sh/til/nix/nix-macos-setup/)

1. Install nix - [https://zero-to-nix.com/](https://zero-to-nix.com/)
2. Install nix-darwin - [https://github.com/LnL7/nix-darwin](https://github.com/LnL7/nix-darwin)
3. Clone this repo - `git clone https://github.com/casualjim/home-manager ~/.config/nix-darwin`
4. The first time you use this: `nix run nix-darwin -- switch --flake ~/.config/nix-darwin`
5. After that you can just use `darwin-rebuild switch --flake ~/.config/nix-darwin`

This will enable touchid for sudo and **keep it enabled**.
This will also install devenv so you can use [https://devenv.sh/](https://devenv.sh/)