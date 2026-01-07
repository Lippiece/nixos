{
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

    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

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

  systemd.services.caddy.preStart = "chmod -R a+rx /var/lib/caddy/";
  networking.firewall.extraCommands = ''
    iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353
    iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-port 5353
  '';

  services.caddy = {
    enable = true;
    enableReload = true;
    virtualHosts = {
      "lipcloud.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:11000
        '';
      };
      "lipsearch.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3001
        '';
      };
      "warden.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3002
        '';
      };
      "lipgit.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3003
        '';
      };
      "lipgrammar.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3006
        '';
      };
      "lipguard.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3007
        '';
      };
      "lipoffice.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3010
        '';
      };
      "liprss.ydns.eu" = {
        extraConfig = ''
          reverse_proxy localhost:3011
        '';
      };
      "matrix.lippiece.ru" = {
        extraConfig = ''
                   handle_path /.well-known/matrix/* {
            root * /etc/caddy/well-known-matrix
            file_server
            header Access-Control-Allow-Origin *
            header Content-Type application/json
          }

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
      "matrix.lippiece.ru:3478" = {
        extraConfig = ''
          reverse_proxy localhost:4200
        '';
      };
      "matrix.lippiece.ru:5349" = {
        extraConfig = ''
          reverse_proxy localhost:4200
        '';
      };
      "matrixrtc.lippiece.ru" = {
        extraConfig = ''
          handle /sfu/get {
            reverse_proxy localhost:4230
          }
          handle {
            reverse_proxy localhost:4240
          }
        '';
      };
    };
  };
}
