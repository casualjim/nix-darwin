{ username, hostname }:
{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases =
      let
        commonAliases = {
          l = "eza -lh --icons --git";
          ls = "eza --icons -G";
          lsa = "eza --icons -lah --git";
          ll = "eza --icons -lh --git";
          la = "eza --icons -lah --git";
          tree = "eza --tree --icons";
          vim = "nvim";
          ping = "prettyping --nolegend";
          humanlog = "humanlog --skip-unchanged=false --truncate=false";
        };
        workAliases =
          if hostname == "archimedes" then
            {
              ktest = "kubectl --context infraapi-test";
              kprod = "kubectl --context infraapi-prod";
            }
          else
            { };
      in
      commonAliases // workAliases;

    localVariables =
      let
        commonVariables = {
          ZSH_CACHE_DIR = "$HOME/Library/Caches/antidote";
        };
        workVariables =
          if hostname == "archimedes" then
            {
              KUBECACHEDIR = "$HOME/Library/Caches/kubectl";
            }
          else
            { };
      in
      commonVariables // workVariables;

    initExtraBeforeCompInit = ''
      export ZSH_CACHE_DIR
      [[ ! -d $HOME/Library/Caches/antidote/completions ]] && mkdir -p $ZSH_CACHE_DIR/completions
    '';

    initExtra = ''
      . "${pkgs.grc}/etc/profile.d/grc.sh"

      cat() { bat --paging never --plain --plain "$@" }

      if [ $commands[direnv] ]; then
        eval "$(direnv hook zsh)"
      fi

      if [ $commands[hub] ]; then
        eval "$(hub alias -s)"
      fi

      if [ $commands[prettyping] ]; then
        alias ping='prettyping --nolegend'
      fi
    '';

    envExtra = ''
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
}
