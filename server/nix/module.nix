self: {
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.services.showcaseServer;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) showcase-server vm-package-recipe;
  vm-package = vm-package-recipe {
    gdPath = cfg.gdDir;
  };
  vmBinary = "${vm-package}/bin/microvm-run";
in {
  options.services.showcaseServer = {
    enable = mkEnableOption "showcaseServer";
    gdDir = mkOption {
      type = types.str;
      default = "/var/lib/showcase-server/gd";
      description = "The directory of Geometry Dash. Make sure the directory is writable by the dynamic user";
    };
    postgres = {
      username = mkOption {
        type = types.str;
        default = "showcase";
        description = "The username for the PostgreSQL database";
      };
      password = mkOption {
        type = types.str;
        default = "showcase";
        description = "The password for the PostgreSQL database";
      };
      hostname = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The PostgreSQL server hostname";
      };
      port = mkOption {
        type = types.int;
        default = 5432;
        description = "The PostgreSQL server port";
      };
      databaseName = mkOption {
        type = types.str;
        default = "showcase";
        description = "The PostgreSQL database name";
      };
    };
    httpPort = mkOption {
      type = types.int;
      default = 8080;
      description = "The port to run the http server on";
    };
    hostname = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The hostname to bind to";
    };
  };

  config = mkIf cfg.enable {
    # security.wrappers.player_binary_suid = {
    #   source = "${vmBinary}";
    #   owner = "root";
    #   group = "root";
    #   # setuid = true;
    #   permissions = "u+rx,g+rx,o+rx";
    #   capabilities = "cap_net_admin+ep";
    # };
    environment.systemPackages = [
      vm-package
    ];

    systemd.services.showcase-server = {
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      startLimitIntervalSec = 60;
      description = "Start Showcase server";
      serviceConfig = {
        # DynamicUser = true;
        StateDirectory = "showcase-server";
        ExecStart = pkgs.writeShellScript "showcase-server-exec-start" ''
          # remove the old directory
          rm -rf /tmp/showcase-server
          # make tmp dir in /tmp
          mkdir -p /tmp/showcase-server
          # make sure the directory is writable by the dynamic user
          chown -R $USER:$USER /tmp/showcase-server
          cd /tmp/showcase-server
          ${showcase-server}/bin/showcase_server \
            --gd-dir ${cfg.gdDir} \
            --pg-username ${cfg.postgres.username} \
            --pg-password ${cfg.postgres.password} \
            --pg-hostname ${cfg.postgres.hostname} \
            --pg-port ${toString cfg.postgres.port} \
            --pg-database-name ${cfg.postgres.databaseName} \
            --player-binary ${vmBinary} \
            --http-port ${toString cfg.httpPort} \
        '';
      };
    };
  };
}
