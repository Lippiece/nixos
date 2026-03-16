# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  mail = "lippiece@vivaldi.net";
  name = "lippiece";
  smtphost = "smtp.vivaldi.net";

  mailDW = {
    mail = "a.anisko@ddemo.ru";
    name = "a.anisko";
    smtphost = "smtp.dw.team";
  };
in {
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/d97cee83-4277-4653-bf49-9280b6dcd10a";
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = lib.mkDefault "Europe/Kaliningrad";

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
    libinput = {
      enable = true;
      touchpad = {
        horizontalScrolling = true;
        naturalScrolling = true;
        middleEmulation = true;
        clickMethod = "buttonareas";
        scrollMethod = "edge";
        tapping = false;
      };
    };

    xserver.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
    desktopManager.plasma6.enable = true;
    openssh.enable = true;
    dnsproxy = {
      enable = true;
      settings = {
        bootstrap = ["tls://9.9.9.9:853"];

        # Plain DNS upstream
        # upstream = [ "1.1.1.1:53" ];
        # DNS over TLS upstream
        # upstream = [ "tls://dns.adguard.com" ];
        # DNS over HTTPS upstream
        upstream = ["quic://lipguard.ydns.eu"];
      };
      # Additional launch flags
      # flags = [ "--verbose" ];
    };

    automatic-timezoned.enable = true;

    # Load nvidia driver for Xorg and Wayland
    xserver.videoDrivers = ["nvidia"];

    btrfs.autoScrub.enable = true;

    beesd.filesystems = {
      root = {
        spec = "/";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = ["--loadavg-target" "5.0"];
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_ENABLE_WAYLAND = "1";
      BROWSER = "brave";
      MANPAGER = "nvim +Man!";
    };
    etc."xdg/kcminputrc".text = ''
      [Keyboard]
      NumLock=0
    '';
    systemPackages = with pkgs; [
      # Essential
      wget
      bat
      unar
      git
      silver-searcher
      (
        kdotool.overrideAttrs (finalAttrs: previousAttrs: {
          version = "1ad61acb56c0707df53a4d9ce10153a87f08523b";
          src = fetchFromGitHub {
            owner = "jinliu";
            repo = "kdotool";
            rev = "049e3f5620ad8c5484241d7d06d742bc17d423ed";
            hash = "sha256-8pKPVOj0fMwzzuNehG+vbDxKn+wfpWoiYabl5wkcQtc=";
          };
          cargoDeps = rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            hash = "sha256-CZr/aPAPFjeJdlF8wvf1c16bBGhzGhVW3WnZJ8TC68A=";
          };
          patches = [];
        })
      )
      gcc
      vlc
      btop
      glances
      unzip
      tree

      # Libs & tools
      icu
      kdePackages.kaccounts-providers
      kdePackages.kaccounts-integration
      kdePackages.accounts-qt
      kdePackages.korganizer
      kdePackages.kdepim-addons
      kdePackages.signond
      kdePackages.kontact
      kdePackages.akonadi
      kdePackages.qtwebengine
      sqlite
      mariadb
      libinput
      libnotify
      inotify-tools
      kdePackages.qtimageformats
      libwebp

      # For `pactl`
      pulseaudio
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lippiece = {
    isNormalUser = true;
    extraGroups = ["wheel" "sudo"]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    # ];
    hashedPasswordFile = "/persist/pass";
    # shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;
  users.mutableUsers = false;

  # List packages installed in system profile.

  # Some Programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      settings = {
        default-cache-ttl = 86400;
        max-cache-ttl = 86400;
      };
    };
    ssh.startAgent = true;
    fish = {
      enable = true;
      generateCompletions = true;
      useBabelfish = true;
    };
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    #   withNodeJs = true;
    # };
    nix-ld.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    lazygit = {
      enable = true;
      # package = pkgs.buildGoModule rec {
      #   pname = "lazygit";
      #   version = "unstable-2025-08-06";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "jesseduffield";
      #     repo = "lazygit";
      #     rev = "c08903e3adabcf00d910e0107c1f675af958a70e";
      #     sha256 = "1f1r7gkpyqwg8b6vg9h46zncdrm9i5xxlqkslziqxd3jm5w9afri";
      #   };
      #   vendorHash = null;
      #   doCheck = false;
      #   ldflags = ["-X main.version=${version}" "-X main.buildSource=nix"];
      #   meta = with pkgs.lib; {
      #     description = "Simple terminal UI for git commands";
      #     homepage = "https://github.com/jesseduffield/lazygit";
      #     license = licenses.mit;
      #     mainProgram = "lazygit";
      #   };
      # };
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.dates = "weekly";
      flake = "/home/lippiece/.config/nixos";
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    npm.enable = true;
    dconf.enable = true;
    firefox = {
      enable = true;
      nativeMessagingHosts.packages = with pkgs; [kdePackages.plasma-browser-integration tridactyl-native];
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
    kde-pim = {
      enable = true;
      kontact = true;
    };
    msmtp = {
      enable = true;
      accounts = {
        ${mail} = {
          auth = true;
          # try setting `tls_starttls` to `false` if sendmail hangs
          tls = true;
          from = mail;
          host = smtphost;
          user = "${name}";
          passwordeval = "pass ${mail}";
        };

        ${mailDW.mail} = {
          auth = true;
          tls = true;
          from = mail;
          host = mailDW.smtphost;
          user = "${mailDW.name}";
          passwordeval = "pass ${mailDW.mail}";
        };
      };
    };
    command-not-found.enable = false;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            unrar
            p7zip
            alsa-lib.out
            libsForQt5.libqtpas.out
            at-spi2-atk.out
            cairo.out
            cups.lib
            dbus.lib
            expat.out
            glib.out
            gtk3.out
            libdrm.out
            libgbm.out
            libxkbcommon.out
            nspr.out
            nss.out
            pango.out
            libX11.out
            libXcomposite.out
            libXdamage.out
            libXext.out
            libXfixes.out
            libXrandr.out
            libxcb.out

            libXcursor.out
            libXi.out
            libXinerama.out
            libXrender.out
            libGL.out

            SDL2.out
            SDL2_image.out
            SDL2_mixer.out
            SDL2_ttf.out
            libgcc.lib
            udev

            freetype.out
            libz.out
          ];
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    chromium = {
      enablePlasmaBrowserIntegration = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # Enable the DNS proxy.
  networking = {
    hostName = "mothership"; # Define your hostname.
    extraHosts = ''
      192.168.1.1 mwlogin.net

      192.168.1.102      cumulonimbus
      192.168.1.102:3001 lipsearch.ydns.eu
      192.168.1.102:3002 warden.ydns.eu
      192.168.1.102:3003 lipgit.ydns.eu
      192.168.1.102:3009 lipguard.ydns.eu

      192.168.1.201      yuos
    '';

    firewall.enable = false;

    networkmanager.enable =
      true; # Easiest to use and most distros use this by default.
    # If using NetworkManager:
    networkmanager.dns = "none";
    nameservers = ["127.0.0.1"];

    useDHCP = lib.mkDefault true;
    enableIPv6 = false;
  };
  # networking.networkmanager.dns = "systemd-resolved";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete `configuration.nix`.
  # system.copySystemConfiguration = true;

  system = {
    autoUpgrade = {
      flake = inputs.self.outPath;
      flags = [
        "--upgrade-all"
        "--print-build-logs"
        "--commit-lock-file"
      ];
      dates = "weekly";
      operation = "switch";
      persistent = true;
      enable = true;
    };

    # Most users should NEVER change this value after the initial install, for any reason,
    stateVersion = "25.05";
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useUserPackages = true;

    users.lippiece = ../home-manager/home.nix;
  };

  i18n = {
    extraLocales = ["ru_RU.UTF-8/UTF-8"];
    defaultLocale = "en_GB.UTF-8";
  };

  fonts = {
    packages = with pkgs; [
      maple-mono.truetype-autohint
      inter-nerdfont
      nerd-fonts.symbols-only
      nerd-fonts.liberation

      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Inter Variable" "Noto Serif"];
        sansSerif = ["Inter Variable" "Noto Sans"];
        monospace = ["Maple Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
    enableDefaultPackages = true;
  };

  nix = {
    optimise = {
      automatic = true;
      persistent = true;
      dates = "daily";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      cores = 8;
      max-jobs = 8;
      auto-optimise-store = true;
      keep-going = true;
    };
    package = pkgs.lixPackageSets.latest.lix;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    extraOptions = ''
      use-xdg-base-directories = true
    '';
  };

  # Enable common container config files in /etc/containers
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

    # spiceUSBRedirection.enable = true;
  };

  security = {
    pam = {
      services.login.enableKwallet = lib.mkForce false;
      loginLimits = [
        {
          domain = "@users";
          type = "soft";
          item = "priority";
          value = "1";
        }
      ];
    };
    sudo.extraConfig = ''
      Defaults timestamp_timeout=7200
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  systemd = {
    services = {
      nixos-upgrade = {
        serviceConfig.EnvironmentFile = "/home/lippiece/.config/nixos/.env";
        serviceConfig.WorkingDirectory = "/home/lippiece/.config/nixos";
        serviceConfig.ExecStartPre = ["/run/current-system/sw/bin/nix flake update"];
        unitConfig = {
          After = ["dnsproxy.service"];
          Wants = ["dnsproxy.service"];
        };
      };
    };

    timers = {
      nixos-upgrade.timerConfig.WakeSystem = "yes";
      nix-optimise.timerConfig.WakeSystem = "yes";
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  # Enable OpenGL
  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot =
      true; # powers up the default Bluetooth controller on boot

    nvidia = {
      # open = lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);
      open = true;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        # Needed for finegrained power management to work
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };

      # modesetting.enable = true;

      # Causes sleep and suspend to fail.
      # powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # powerManagement.finegrained = true;

      nvidiaSettings = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
}
