# @ts: { lib: Lib; pkgs: Nixpkgs; stdenv: Stdenv; [key: string]: any }
# Nixpkgs — top-level pkgs object
# Lib — all nixpkgs lib functions (lib.concatStringsSep, lib.optionalString, etc.)
# Stdenv — mkDerivation, hostPlatform, cc, etc.
# Platform — isLinux, isDarwin, system, etc.
# Derivation — standard derivation output type
{
  pkgs,
  lib,
  inputs,
  rimsortUnfree,
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
    cinny-desktop
    kitty
    # TODO: deno builds for hours
    # qimgv

    inputs.brave-origin.packages.${pkgs.system}.default
    # (brave.overrideAttrs (oldAttrs: {
    #   nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [makeWrapper];
    #   postInstall = ''
    #     wrapProgram "$out/bin/brave" \
    #       --add-flags "--proxy-server=socks5://127.0.0.1:2334"
    #   '';
    # }))

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
    qbittorrent-enhanced
    # TODO: openldap-2.6.13-i686-linux failed with exit code 2
    # (bottles.override {
    #   removeWarningPopup = true;
    # })
    # variety # random wallpaper
    # prismlauncher
    # (pkgs.callPackage ../../packages/rimsort/package.nix {})
    rimsortUnfree.rimsort

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
    nodejs
    deno
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
    (pkgs.callPackage ../../packages/git_bayesect/package.nix {})
    git-town

    # # Nix
    alejandra
    update-nix-fetchgit
    inputs.typenix.packages.x86_64-linux.default

    # # Mutt
    mutt-wizard
    urlscan
    lynx

    # # Rust
    # rustc
    # rustup
  ];

  # Home Manager is pretty bad at managing dotfiles. The primary way to manage
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

    ".config/BraveSoftware/Brave-Origin/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    ".config/BraveSoftware/Brave-Origin/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".text = ''
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

    ".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json".text = ''
              {
          "allowed_extensions": [
              "keepassxc-browser@keepassxc.org"
          ],
          "description": "KeePassXC integration with native messaging support",
          "name": "org.keepassxc.keepassxc_browser",
          "path": "${pkgs.keepassxc}/bin/keepassxc-proxy",
          "type": "stdio"
      }
    '';

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    "bunfig.toml".text =
      #toml
      ''
        [install]
        minimumReleaseAge = 60480 # 7 days in seconds
      '';

    # elvish
    ".config/elvish/rc.elv".text =
      # elvish
      ''
        set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
        eval (carapace _carapace|slurp)
        eval (starship init elvish)

        use extend
        use functions
      '';
  };
  home.shell = {
    enableFishIntegration = false;
  };
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    EDITOR = "nvim";
    BROWSER = "firefox-nightly";
    MANPAGER = "nvim +Man!";
    SHELL = lib.getExe pkgs.elvish;
  };

  # Let Home Manager install and manage itself.
  programs = {
    fish.enable = false;
    home-manager.enable = true;

    bat.enable = true;

    dircolors.enable = true;

    eza = {
      enable = true;
      icons = "auto";
    };

    pay-respects = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };

    git = {
      enable = true;
      # delta.enable = true;
      signing.signByDefault = true;
      userEmail = "github@lippiece.anonaddy.me";
      userName = "${name}";
    };

    diff-so-fancy = {
      enable = true;
      changeHunkIndicators = true;
      enableGitIntegration = true;
    };

    tealdeer.enable = true;

    password-store = {
      enable = true;
    };

    nix-index = {
      enable = true;
    };

    command-not-found.enable = false;
    carapace = {
      enable = true;
    };

    gpg.enable = false;

    tmux = {
      enable = true;
      escapeTime = 10;
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
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
    };

    # brave = {
    #   enable = true;
    #   package = inputs.brave-origin.packages.${pkgs.system}.default;
    #   # nativeMessagingHosts = [
    #   # pkgs.kdePackages.plasma-browser-integration
    #   # "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json"
    #   # ];
    # };
  };

  xdg = {
    configFile."shell".source = lib.getExe pkgs.elvish;
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

    podman = {
      enable = true;
      enableTypeChecks = true;
      # containers = {
      #   foo = {
      #     autoUpdate = "registry";
      #     image = "docker.io/hello-world";
      #   };
      # };
    };
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

  xdg.desktopEntries = {
    catapult = {
      name = "Catapult";
      exec = ''fish -c "runbuild /home/lippiece/.config/nixos/packages/catapult catapult"'';
      terminal = false;
    };
  };
}
