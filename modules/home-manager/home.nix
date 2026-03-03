{
  pkgs,
  lib,
  inputs,
  ...
}: let
  name = "lippiece";
in {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./nixvim.nix
  ];
  home.username = "${name}";
  home.homeDirectory = "/home/lippiece";

  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "25.05";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # NOTE: It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # NOTE: You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    #################################
    #              GUI              #
    #################################

    # # Tools
    xray

    #################################
    #              CLI              #
    #################################

    # # vim
    # neovide
    # neovim
    # fzf
    # lua54Packages.luarocks
    # gnumake
    # python312Packages.pip
    # python3Full
    # python312Packages.venvShellHook
    # uv
    # cargo
    # nodejs_latest
    # ripgrep
    python313Packages.demjson3

    # # Shell
    # bun
    so
    imagemagick
    wl-clipboard-rs
    pass-git-helper
    proxychains-ng
    commitizen
    gh
    # steamcmd
    rsync
    tomb

    # # Nix
    alejandra
    update-nix-fetchgit
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  home.shell = {
    enableFishIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    bat.enable = true;

    dircolors.enable = true;

    eza = {
      enable = true;
      icons = "auto";
      enableFishIntegration = true;
    };

    fd = {
      enable = true;
      hidden = true;
    };

    fish = {
      enable = true;
      generateCompletions = true;
      plugins = [
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "998ad4f5fc9cee36c09840a7e635b56428e554f9";
            sha256 = "1ggjz9z95r46bdsfp8mrs07si6hc97hw9vx5qwgbfzc4qsjmk78r";
          };
        }
        {
          name = "puffer-fish";
          src = pkgs.fetchFromGitHub {
            owner = "nickeb96";
            repo = "puffer-fish";
            rev = "83174b07de60078be79985ef6123d903329622b8";
            sha256 = "0a4x985hzv77r5q8cly6580n488pf5iqlwkifrhzj9kifkwpj70f";
          };
        }
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "fcda500d2c2996e25456fb46cd1a5532b3157b16";
            sha256 = "0zg4ydsjs163n89i6a1fcv2j82qph7wx3cwrb8mzsq2v5mh08dkp";
          };
        }
      ];
      interactiveShellInit = ''
        set -U __done_min_cmd_duration 1000
      '';
    };

    pay-respects = {
      enable = true;
      enableFishIntegration = false;
    };

    git = {
      enable = true;
      # delta.enable = true;
      diff-so-fancy.enable = true;
      diff-so-fancy.changeHunkIndicators = true;
      signing.signByDefault = true;
      userEmail = "github@lippiece.anonaddy.me";
      userName = "${name}";
    };

    tealdeer.enable = true;

    password-store = {
      enable = true;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    command-not-found.enable = false;
    carapace = {
      enable = true;
      enableFishIntegration = true;
    };

    gpg.enable = true;

    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        resurrect
        harpoon
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "ssh-session cwd continuum attached-clients"

            set -g @dracula-show-powerline true
            set -g @dracula-show-battery false
            set -g @dracula-show-location false
            set -g @dracula-show-timezone false

            set -g @dracula-synchronize-panes-label "Sync"
            set -g @dracula-synchronize-panes-auto-hide true

            set -g @dracula-show-ssh-only-when-connected true

            set -g @dracula-ping-rate -1

            set -g @dracula-cwd-max-dirs "2"
            set -g @dracula-cwd-max-chars "20"

            set -g @dracula-battery-label false
            set -g @dracula-show-battery-status false

            set -g @dracula-clients-minimum 1
          '';
        }
        tmux-which-key
      ];
      newSession = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      extraConfig =
        # tmux
        ''
          bind c new-window -c "#{pane_current_path}"

          bind '"' split-window -c "#{pane_current_path}"
          bind % split-window -h -c "#{pane_current_path}"

          # In vi copy mode, press 'y' to copy but remain in copy-mode
          bind -T copy-mode-vi y send -X copy-selection

          # `open` the selected text
          bind -T copy-mode-vi o send-keys -X copy-pipe-and-cancel "xargs open"
        '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      # enableFishIntegration = true;
    };
    alacritty = {
      enable = true;
      settings = {
        general = {
          import = ["~/.config/alacritty/themes/themes/gruvbox_dark.toml"];
        };
        font = {
          normal = {
            family = "0xProto Nerd Font";
            style = "Regular";
          };
        };
        mouse = {
          hide_when_typing = true;
        };
        window = {
          opacity = 0.9;
          blur = true;
        };
      };
    };
  };

  services = {
    ssh-agent.enable = true;
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Inter Variable" "Noto Serif"];
        sansSerif = ["Inter Variable" "Noto Sans"];
        monospace = ["0xProto Nerd Font Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  systemd.user = {
    services = {
      "ydns-updater" = {
        Unit = {
          After = ["network.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.bash} /home/lippiece/bin/updater.sh";
          Environment = "PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
        };
      };
    };
    timers = {
      "ydns-updater" = {
        Install = {
          WantedBy = ["timers.target"];
        };
        Unit = {
          After = ["network.target"];
        };
        Timer = {
          OnBootSec = "5m";
          OnUnitInactiveSec = "4h";
        };
      };
    };
  };
}
