{
  config,
  pkgs,
  lib,
  ...
}:
let
  homeManagerVars = builtins.removeAttrs config.home-manager.users.ivan.home.sessionVariables [
    "MANPAGER"
  ];
  homeManagerPath = config.home-manager.users.ivan.home.sessionPath;

  # Handle MANPAGER separately with proper quote escaping
  manpagerValue = "sh -c \"col -bx | bat -l man -p\"";

  # Create a script that sets up the environment
  envSetupScript = pkgs.writeScript "setup-env" ''
    #!${pkgs.zsh}/bin/zsh -e

    # Set library paths
    export LIBRARY_PATH="${
      lib.concatStringsSep ":" [
        "${pkgs.libiconv}/lib"
        "/System/Library/Frameworks/CoreServices.framework"
        "/System/Library/Frameworks/CoreFoundation.framework"
        "/System/Library/Frameworks/Security.framework"
        "/System/Library/Frameworks/SystemConfiguration.framework"
      ]
    }"

    export NIX_LDFLAGS="-L${pkgs.libiconv}/lib -liconv $NIX_LDFLAGS"

    # Set PATH with proper ordering, preserving existing entries
    local new_path="${
      lib.concatStringsSep ":" (
        [
          # Nix profile paths
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
          "/etc/profiles/per-user/ivan/bin"
          "/Users/ivan/.nix-profile/bin"
        ]
        ++ homeManagerPath
        ++ [
          # System paths
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ]
      )
    }"

    # Preserve any additional paths that might be set by other tools
    if [ -n "$PATH" ]; then
      # Get unique paths while preserving order
      local old_paths=$(echo ''${PATH} | tr ':' '\n')
      local new_paths=$(echo ''${new_path} | tr ':' '\n')
      export PATH=$(echo -e "''${new_paths}\n''${old_paths}" | awk '!seen[$0]++' | tr '\n' ':' | sed 's/:$//')
    else
      export PATH="$new_path"
    fi

    # Set MANPAGER
    export MANPAGER='${manpagerValue}'

    # Set home-manager variables
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "export ${name}='${toString value}'") homeManagerVars
    )}

    # Also set these in the GUI context using launchctl
    ${lib.concatStringsSep "\n" (
      [
        "launchctl setenv LIBRARY_PATH \"$LIBRARY_PATH\""
        "launchctl setenv NIX_LDFLAGS \"$NIX_LDFLAGS\""
        "launchctl setenv PATH \"$PATH\""
        "launchctl setenv MANPAGER \"$MANPAGER\""
      ]
      ++ lib.mapAttrsToList (
        name: value: "launchctl setenv ${name} \"${toString value}\""
      ) homeManagerVars
    )}
  '';
in
{
  # Add the script to system packages
  environment.systemPackages = with pkgs; [
    libiconv
  ];

  # Set up environment for shell and GUI applications
  programs.zsh.interactiveShellInit = ''
    # Source the environment setup script
    source ${envSetupScript}

        # Ensure the LaunchAgents directory exists
        mkdir -p ~/Library/LaunchAgents

        # Create a LaunchAgent to set environment variables
        cat > ~/Library/LaunchAgents/org.nixos.env.plist << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>org.nixos.env</string>
        <key>ProgramArguments</key>
        <array>
            <string>${envSetupScript}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOF

        # Load the LaunchAgent if not already loaded
        launchctl list org.nixos.env >/dev/null 2>&1 || launchctl load ~/Library/LaunchAgents/org.nixos.env.plist
  '';
}
