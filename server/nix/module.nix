self: {
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.services.showcaseServer;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) showcase-server;
in {
  options.services.showcaseServer = {
    enable = mkEnableOption "showcaseServer";
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/showcase-server/data";
      description = "The directory to store data in";
    };
    gdDir = mkOption {
      type = types.str;
      default = "/var/lib/showcase-server/geometry-dash";
      description = "The directory to store Geometry Dash files in";
    };
    # TODO, use this
    serverPort = mkOption {
      type = types.int;
      default = 8080;
      description = "The port to run the Showcsae server on";
    };
    # TODO, use this
    modSocketPort = mkOption {
      type = types.int;
      default = 8081;
      description = "The local port to talk with the Showcsae mod on";
    };
    # TODO, use this
    hostname = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The hostname to bind to";
    };
    user = mkOption {
      type = types.str;
      default = "showcase";
      description = "User to run the service as";
    };
    userUID = mkOption {
      type = types.int;
      default = 1555;
      description = "The User's UID";
    };
    createUser = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to create the user";
    };
  };

  config = mkIf cfg.enable {
    users = mkIf cfg.createUser {
      users.${cfg.user} = {
        uid = cfg.userUID;
        description = "User for the Showcase server";
        createHome = true;
        isNormalUser = true;
        home = cfg.dataDir;
        group = cfg.user;
      };
      groups.${cfg.user} = {};
    };
    systemd.services.showcase-server = {
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      startLimitIntervalSec = 60;
      description = "Start Showcase server";
      serviceConfig = {
        # username that systemd will look for; if it exists, it will start a service associated with that user
        User = cfg.user;
        # the command to execute when the service starts up
        ExecStart = pkgs.writeShellScript "showcase-server-exec-start" ''
          ${showcase-server}/bin/showcase-server --data-dir ${cfg.dataDir} --gd-dir ${cfg.gdDir}
        '';

        Environment = [
          "PATH=${lib.makeBinPath (with pkgs; [
            coreutils
            bashInteractive
            systemd
          ])}"
        ];
      };
    };
  };
}
