{lib, ...}: let
  knotUrl = "tangled.lippiece.cc";
  spindleUrl = "spindle.lippiece.cc";
  # appviewUrl = "appview.lippiece.cc";
in {
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

  systemd = {
    paths = {
      adguard-certs-changed = {
        wantedBy = ["caddy.service"];
        enable = true;
        pathConfig = {
          PathChanged = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/lipguard.lippiece.cc/";
          Unit = "copy-adguard-certs.service";
        };
      };
    };
    services = {
      copy-adguard-certs = {
        description = "Copy AdguardHome domain Caddy certs to ~/.cache, readable by lippiece";
        script = ''
          install -m 440 --owner lippiece \
          /var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/lipguard.lippiece.cc/* \
          /home/lippiece/.cache/lipguard.lippiece.cc/
        '';
      };
      spindle.environment = {
        SPINDLE_SERVER_DOCKER_SOCKET = "/var/run/podman/podman.sock";
        HTTPS_PROXY = "socks5://127.0.0.1:2334";
      };
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
      "lipsearch.lippiece.cc".extraConfig = ''reverse_proxy localhost:3001'';
      "warden.lippiece.cc".extraConfig = ''reverse_proxy localhost:3002'';
      "lipgit.lippiece.cc".extraConfig = ''reverse_proxy localhost:3003'';
      "lipguard.lippiece.cc".extraConfig = ''reverse_proxy localhost:3007'';
      "liprss.lippiece.cc".extraConfig = ''reverse_proxy localhost:3011'';
      "roundcube.lippiece.cc".extraConfig = "reverse_proxy localhost:3400";

      "matrixrtc.lippiece.cc" = {
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
      "continuwuity.lippiece.cc".extraConfig = ''reverse_proxy localhost:4300'';
      "${knotUrl}".extraConfig = ''reverse_proxy localhost:3501'';
      "${spindleUrl}".extraConfig = ''reverse_proxy localhost:3502'';
      # "${appviewUrl}".extraConfig = ''reverse_proxy localhost:3503'';
    };
  };

  services = {
    tangled.spindle = {
      enable = true;
      server = {
        listenAddr = "0.0.0.0:3502";
        hostname = spindleUrl;
        owner = "did:plc:anrarapxxzxsdodcnprczsq5";
      };
      pipelines.workflowTimeout = "10m";
    };
    # tangled.appview = {
    #   enable = true;
    #   port = 3503;
    #   appviewHost = appviewUrl;
    #   resend.sentFrom = "lippiece@vivaldi.net";
    #
    #   # TODO: ssh
    #   # ssh = {};
    # };
  };
}
