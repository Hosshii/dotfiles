{ config
, lib
, ...
}:
let
  cfg = config.custom.pmset;
  pmset =
    flag: settings:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (
          name: value: lib.optionalString (value != null) "pmset ${flag} ${name} ${toString value}"
        )
        settings
    );
in
{
  options.custom.pmset = {
    displaysleep = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "display sleep timer in minute(0 to disable)";
    };
    sleep = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "display sleep timer in minute(0 to disable)";
    };
  };

  config = {
    system.activationScripts = {
      extraActivation.text = lib.mkAfter config.system.activationScripts.pmset.text;
      pmset.text = ''
        echo >&2 "configuring power management..."
        ${pmset "-a" cfg}
      '';
    };
  };
}
