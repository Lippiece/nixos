{lib, ...}: {
  users.users.lippiece = {
    # replace `<USERNAME>` with the actual username
    extraGroups = [
      "wheel"
      "podman"
      "caddy"
    ];
  };

  virtualisation = {
    containers.enable = true;
    docker.enable = lib.mkForce false;

    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  environment.etc."caddy/well-known-matrix/client".text = ''
      {
        "m.homeserver": {
            "base_url": "https://matrix.lippiece.ru"
        },
        "m.identity_server": {
            "base_url": "https://vector.im"
        },
        "org.matrix.msc2965.authentication": {
            "issuer": "https://matrix.lippiece.ru/",
            "account": "https://matrix.lippiece.ru/account"
        },
        "org.matrix.msc4143.rtc_foci":[
            {
                "type": "livekit",
                "livekit_service_url": "https://matrixrtc.lippiece.ru"
            }
        ]
    }
  '';

  systemd.services = {
    caddy.preStart = "chmod -R a+rx /var/lib/caddy/";
    spindle.environment = {
      SPINDLE_SERVER_DOCKER_SOCKET = "/var/run/podman/podman.sock";
    };
  };

  networking.firewall.extraCommands = ''
    iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353
    iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-port 5353
  '';

  services.caddy = {
    enable = true;
    enableReload = true;
    virtualHosts = {
      "lipcloud.ydns.eu".extraConfig = ''
        vars /_matrix/push/v1/notify request_uri /index.php/apps/uppush/gateway/matrix
        vars request_uri {uri}

        reverse_proxy localhost:11000

        php_fastcgi localhost:11000 {
          root /var/www/html/nextcloud
          env REQUEST_URI {vars.request_uri}
        }
      '';
      "lipsearch.lippiece.ru".extraConfig = ''reverse_proxy localhost:3001'';
      "warden.lippiece.ru".extraConfig = ''reverse_proxy localhost:3002'';
      "lipgit.lippiece.ru".extraConfig = ''reverse_proxy localhost:3003'';
      "lipguard.lippiece.ru".extraConfig = ''reverse_proxy localhost:3007'';
      "liprss.lippiece.ru".extraConfig = ''reverse_proxy localhost:3011'';
      "roundcube.lippiece.ru".extraConfig = "reverse_proxy localhost:3400";

      "matrix.lippiece.ru" = {
        extraConfig = ''
          handle_path /.well-known/matrix/* {
            root * /etc/caddy/well-known-matrix
            file_server
            header Access-Control-Allow-Origin *
            header Content-Type application/json
          }

          # Unified push to Nextcloud
          @push path /_matrix/push/v1/notify
          rewrite @push localhost:11000/index.php/apps/uppush/gateway/matrix
          reverse_proxy @push localhost:4210

          # Match MAS endpoints first so they don't fall through to Synapse
          @masLogin {
            path_regexp masLogin ^/_matrix/client/.*/login(/.*)?$
          }
          reverse_proxy @masLogin localhost:4210

          @masLogout {
            path_regexp masLogout ^/_matrix/client/.*/logout(/.*)?$
          }
          reverse_proxy @masLogout localhost:4210

          @masRefresh {
            path_regexp masRefresh ^/_matrix/client/.*/refresh(/.*)?$
          }
          reverse_proxy @masRefresh localhost:4210

          @masIdentity {
            path_regexp masRefresh ^/_matrix/identity(/.*)?$
          }
          reverse_proxy @masIdentity localhost:4210

          # Synapse handles the rest
          reverse_proxy /_matrix/* localhost:4200
          reverse_proxy /_synapse/client/* localhost:4200
          reverse_proxy /_synapse/mas/* localhost:4200
          #reverse_proxy /_synapse/admin/* localhost:4200

          # Optional: catch-all to MAS (only if you want it)
          reverse_proxy localhost:4210
        '';
      };
      "matrix.lippiece.ru:8448" = {
        extraConfig = ''
          handle_path /.well-known/matrix/* {
            root * /etc/caddy/well-known-matrix
            file_server
            header Access-Control-Allow-Origin *
            header Content-Type application/json
          }

          handle {
            reverse_proxy /_matrix/* localhost:4200

            reverse_proxy localhost:4210
          }
        '';
      };
      "matrix.lippiece.ru:3478".extraConfig = ''reverse_proxy localhost:4200'';
      "matrix.lippiece.ru:5349".extraConfig = ''reverse_proxy localhost:4200'';
      "matrixrtc.lippiece.ru" = {
        extraConfig = ''
          # for lk-jwt-service
          @lk-jwt-service path /sfu/get* /healthz* /get_token*
          route @lk-jwt-service {
              reverse_proxy 127.0.0.1:4230
          }

          # for livekit
          reverse_proxy 127.0.0.1:4240
        '';
      };
      "continuwuity.lippiece.ru".extraConfig = ''reverse_proxy localhost:4300'';
      "tangled.lippiece.cc".extraConfig = ''reverse_proxy localhost:3501'';
      "spindle.lippiece.cc".extraConfig = ''reverse_proxy localhost:3502'';
    };
  };

  services = {
    tangled.spindle = {
      enable = true;
      server = {
        listenAddr = "0.0.0.0:3502";
        hostname = "spindle.lippiece.cc";
        owner = "did:plc:anrarapxxzxsdodcnprczsq5";
      };
      pipelines.workflowTimeout = "10m";
    };
  };
}
