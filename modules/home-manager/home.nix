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
    ./mail.nix
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
    kdePackages.kclock
    telegram-desktop
    v2rayn
    xray
    obsidian
    (qt6Packages.callPackage ../../packages/mpc-qt/mpc-qt.nix {})
    # mpc-qt
    kdePackages.filelight
    element-desktop
    kitty

    (brave.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [makeWrapper];
      postInstall = ''
        wrapProgram "$out/bin/brave" \
          --add-flags "--proxy-server=socks5://127.0.0.1:2334"
      '';
    }))

    # # Emulators
    # Laggy and can't redirect USB
    # spice-gtk
    # quickemu
    # spice-vdagent

    # # Plasma
    geoclue2

    # # Work
    super-productivity
    onlyoffice-desktopeditors

    # # Entertainment
    webtorrent_desktop
    qbittorrent-enhanced
    (bottles.override {
      removeWarningPopup = true;
    })
    variety
    prismlauncher
    # (pkgs.callPackage ../../packages/rimsort/package.nix {})

    # # System
    colloid-icon-theme
    colloid-gtk-theme
    kdePackages.karousel
    (
      kdePackages.spectacle.override {
        tesseractLanguages = ["rus" "eng"];
      }
    )

    #################################
    #              CLI              #
    #################################

    # # vim
    fzf
    # lua54Packages.luarocks
    # gnumake
    # python312Packages.pip
    # python3Full
    # python312Packages.venvShellHook
    # uv
    # cargo
    nodejs_latest
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
    delta

    # # Nix
    alejandra
    update-nix-fetchgit

    # # Mutt
    mutt-wizard
    urlscan
    lynx

    # # Rust
    # rustc
    # rustup
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    ".config/chromium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".text = ''
      {
        "allowed_origins": [
          "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/",
          "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
          ],
        "description": "KeePassXC integration with native messaging support",
        "name": "org.keepassxc.keepassxc_browser",
        "path": "${pkgs.keepassxc}/bin/keepassxc-proxy",
        "type": "stdio"
      }

    '';

    ".config/chromium/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    ".config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
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
    enableNushellIntegration = true;
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
      enableNushellIntegration = true;
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

    nushell = {
      enable = true;
    };

    pay-respects = {
      enable = true;
      enableFishIntegration = false;
      enableNushellIntegration = false;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = false;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
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
      enableNushellIntegration = true;
    };

    gpg.enable = false;

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
      enableNushellIntegration = true;
    };

    keepassxc = {
      autostart = true;
      enable = true;
      # For available settings, see https://github.com/keepassxreboot/keepassxc/blob/develop/src/core/Config.cpp
      settings = {
        FdoSecrets.Enabled = true; # Enable Secret Service Integration
        SSHAgent.Enabled = true;
        SSHAgent.UseOpenSSH = true;
        Browser.Enabled = true;
        PasswordGenerator = {
          Type = 1;
          WordCount = 6;
          WordSeparator = "-";
        };
        GUI = {
          ApplicationTheme = "dark";
          ColorPasswords = true;
          MinimizeOnClose = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
        };
        General = {
          AutoGeneratePasswordForNewEntries = true;
          ConfigVersion = 2;
          URLDoubleClickAction = 2;
        };
        Security = {
          ClearClipboard = false;
          IconDownloadFallback = true;
          LockDatabaseIdle = false;
          LockDatabaseScreenLock = false;
        };
      };
    };
    git-credential-keepassxc.enable = true;

    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };

  xdg = {
    autostart.enable = true;
    dataFile."dbus-1/services/org.freedesktop.secrets.service".text = ''
      [D-BUS Service]
      Name=org.freedesktop.secrets
      Exec=${pkgs.keepassxc}/bin/keepassxc
    '';
  };

  services = {
    easyeffects.enable = true;
    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
    kdeconnect.enable = true;
    ssh-agent.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "obsidian"
      "steam"
      "steamcmd"
      "steam-unwrapped"
      "rimsort"
      "steamworkspy"
      "codeium"
      "jitsi-meet"
    ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Inter Variable" "Noto Serif"];
        sansSerif = ["Inter Variable" "Noto Sans"];
        monospace = ["Maple Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  gtk = {
    iconTheme = {
      name = "colloid-icon-theme";
      package = pkgs.colloid-icon-theme;
    };
    theme = {
      name = "colloid-gtk-theme";
      package = pkgs.colloid-gtk-theme;
    };
  };
}
