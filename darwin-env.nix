{ config, pkgs, ... }:
{
  environment = {
    variables = {
      LIBRARY_PATH = pkgs.lib.concatStringsSep ":" [
        "${pkgs.libiconv}/lib"
        "/System/Library/Frameworks/CoreServices.framework"
        "/System/Library/Frameworks/CoreFoundation.framework"
        "/System/Library/Frameworks/Security.framework"
        "/System/Library/Frameworks/SystemConfiguration.framework"
      ];
    };

    systemPackages = with pkgs; [
      libiconv
    ];

    extraInit = ''
      export LIBRARY_PATH="$LIBRARY_PATH"
    '';
  };
}
