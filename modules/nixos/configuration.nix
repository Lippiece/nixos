# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  # lib,
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
  imports = ["${inputs.impermanence}/nixos.nix"];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
    # kernelParams = ["psmouse.synaptics_intertouch=0" "i8042.noloop" "i8042.nomux" "i8042.nopnp" "i8042.reset"];
  };

  nixpkgs.config.allowUnfree = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  boot.initrd.luks.devices = {
    root = {
      # Use https://nixos.wiki/wiki/Full_Disk_Encryption
      device = "/dev/disk/by-uuid/f8535674-a608-4421-bba1-9a8a74fee833";
      preLVM = true;
    };
  };

  time.timeZone = "Europe/Kaliningrad";

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
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

  services.xserver.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
    };
  };
  services.desktopManager.plasma6.enable = true;
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  # services.spamassassin = {
  #   enable = true;
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lippiece = {
    isNormalUser = true;
    extraGroups = ["wheel" "sudo"]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    # ];
    hashedPassword = "$6$NBiKVQ9sSyOEws8p$dW1OJV7/VmFZ9H/wiV2Rxg0A73QqCHznqJtIdvGOUZcN0c5tKsBnd3/yLPLve09aF8inl6tgnPVvPxa8w539O/";
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Essential
    wget
    bat
    unar
    git
    fish
    silver-searcher
    kdotool
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
    kdePackages.korganizer
    kdePackages.kdepim-addons
    kdePackages.signond
    kdePackages.kontact
    sqlite
    libinput
    libnotify
    inotify-tools
    kdePackages.qtimageformats
    libwebp

    # For `pactl`
    pulseaudio
  ];

  environment.persistence."/persist" = {
    # hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/usr"
    ];
    files = [
      # { file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };

  environment.sessionVariables = {
    # LIBVA_DRIVER_NAME = "iHD";
    # NIXOS_OZONE_WL = "1";
    PAGER = "nvim -R";
    MANPAGER = "nvim +Man!";
    # HTTP_PROXY = "127.0.0.1:2334";
  };

  # Some Programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
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
      flake = "~/.config/nixos";
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    npm.enable = true;
    dconf.enable = true;
    firefox = {
      enable = true;
      package = inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
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
            xorg.libX11.out
            xorg.libXcomposite.out
            xorg.libXdamage.out
            xorg.libXext.out
            xorg.libXfixes.out
            xorg.libXrandr.out
            xorg.libxcb.out
          ];
      };
    };

    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # Enable the DNS proxy.
  networking = {
    hostName = "mothership"; # Define your hostname.
    extraHosts = ''
      192.168.1.102      cumulonimbus
      192.168.1.102:3001 lipsearch.ydns.eu
      192.168.1.102:3002 warden.ydns.eu
      192.168.1.102:3003 lipgit.ydns.eu
      192.168.1.102:3009 lipguard.ydns.eu

      192.168.1.201 yuos
    '';

    firewall.enable = false;

    networkmanager.enable =
      true; # Easiest to use and most distros use this by default.
    # If using NetworkManager:
    networkmanager.dns = "none";
    nameservers = ["127.0.0.1"];
  };
  # networking.networkmanager.dns = "systemd-resolved";
  services.dnsproxy = {
    enable = true;
    settings = {
      bootstrap = ["9.9.9.9:53"];

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete `configuration.nix`.
  # system.copySystemConfiguration = true;

  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  system.stateVersion = "25.05"; # Did you read the comment?
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };

    users = {"lippiece" = import ../home-manager/home.nix;};
  };

  i18n = {
    extraLocales = ["ru_RU.UTF-8/UTF-8"];
    defaultLocale = "en_GB.UTF-8";
  };

  fonts = {
    packages = with pkgs; [
      inter-nerdfont
      nerd-fonts._0xproto
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
        monospace = ["0xProto Nerd Font Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
    enableDefaultPackages = true;
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    cores = 8;
    max-jobs = 4;
    auto-optimise-store = true;
    keep-going = true;
  };
  nix.package = pkgs.lixPackageSets.latest.lix;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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

  security.pam.loginLimits = [
    {
      domain = "@users";
      type = "soft";
      item = "priority";
      value = "1";
    }
  ];
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=7200
  '';

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
