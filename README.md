# My Home Manager setup

This repo contains my configuration for nix-darwin and home-manager.  I'm very new to all of this so it may be more messy than it could be.

## Installation

I basically followed this guide: [https://davi.sh/til/nix/nix-macos-setup/](https://davi.sh/til/nix/nix-macos-setup/)

### On a mac

1. Install nix - [https://zero-to-nix.com/](https://zero-to-nix.com/)
2. Install nix-darwin - [https://github.com/LnL7/nix-darwin](https://github.com/LnL7/nix-darwin)
3. Clone this repo - `git clone https://github.com/casualjim/nix-darwin ~/.config/nix-darwin`
4. The first time you use this: `nix run nix-darwin -- switch --flake ~/.config/nix-darwin`
5. After that you can just use `darwin-rebuild switch --flake ~/.config/nix-darwin`

This will enable touchid for sudo and **keep it enabled**.
This will also install devenv so you can use [https://devenv.sh/](https://devenv.sh/)

### On a non-nixos linux machine

1. Install nix - [https://zero-to-nix.com/](https://zero-to-nix.com/)
2. Install Home Manager - [Home Manager Standalone Install (unstable)](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

    ```sh
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```

3. Clone this repo - `git clone https://github.com/casualjim/nix-darwin ~/.config/nix-configs`
4. After that you can just use `home-manager switch --flake ~/.config/nix-configs`

## Resources

Along the way I've found these resources very helpful:

* [Original Thesis](https://edolstra.github.io/pubs/phd-thesis.pdf)
* [Nix Pills](https://nixos.org/guides/nix-pills/)
* [Zero To Nix](https://zero-to-nix.com/)
* [Nix Language Basics](https://nix.dev/tutorials/nix-language)
* [Nix Modules](https://nixos.wiki/wiki/NixOS_modules)
* [NixOS Manual](https://nixos.org/manual/nixos/stable/)
* [Home Manager Options](https://github.com/nix-community/home-manager/blob/master/doc/options.md)
* [NixOS Options](https://nixos.org/manual/nixos/stable/options.html)
* [NixOS Search](https://search.nixos.org/)
* [NixOS Wiki](https://nixos.wiki/wiki/Home)
* [NixOS Discourse](https://discourse.nixos.org/)
