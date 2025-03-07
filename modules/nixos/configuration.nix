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
  impermanence =
    builtins.fetchTarball
    "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in {
  imports = ["${impermanence}/nixos.nix"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["btrfs"];
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

  networking.hostName = "mothership"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  networking.extraHosts = ''
    192.168.1.102      cumulonimbus
    192.168.1.102:3001 lipsearch.ydns.eu
    192.168.1.102:3002 warden.ydns.eu
    192.168.1.102:3003 lipgit.ydns.eu
    192.168.1.102:3009 lipguard.ydns.eu
  '';
  # networking.networkmanager.dns = "systemd-resolved";

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
    # touchpad = {
    #   clickMethod = "buttonareas";
    #   scrollMethod = "edge";
    #   tapping = false;
    # };
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
    libnotify
    ripgrep
    libwebp
    kdePackages.qtimageformats
    icu
    vlc
    htop-vim
    unzip
    tree
    gamescope
    gamemode
    kdePackages.kaccounts-providers
    kdePackages.kaccounts-integration
    kdePackages.korganizer
    kdePackages.kdepim-addons
    kdePackages.signond
    # python3
    # python312Packages.pip
    cargo
    nodejs
    # kdePackages.qtbase
    libinput
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
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
    PAGER = "nvim -R";
    MANPAGER = "nvim +Man!";
    # HTTP_PROXY = "127.0.0.1:2334";
  };

  # Some Programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    glib
    glibc
    nss
    nspr
    atk
    cups
    dbus
    libdrm
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libxkbcommon
    mesa
    expat
    xorg.libxcb
    alsa-lib
    libGL
    libsecret
  ];
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  programs.lazygit.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "daily";
    flake = /home/lippiece/.config/nixos;
  };
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.npm.enable = true;
  programs.dconf.enable = true;
  # programs.java.enable = true;
  programs.chromium.enablePlasmaBrowserIntegration = true;
  programs.firefox.nativeMessagingHosts.packages = with pkgs; [kdePackages.plasma-browser-integration];
  programs.kde-pim = {
    enable = true;
    kontact = true;
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
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete `configuration.nix`.
  system.copySystemConfiguration = true;

  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  system.stateVersion = "25.05"; # Did you read the comment?
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  home-manager = {
    extraSpecialArgs = {inherit inputs;};

    users = {"lippiece" = import ../home-manager/home.nix;};
  };

  i18n = {
    supportedLocales = ["ru_RU.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8"];
    defaultLocale = "en_GB.utf8";
    # extraLocaleSettings = {LANGUAGE = "en_GB.UTF-8";};
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      inter-nerdfont
      nerd-fonts._0xproto
      liberation_ttf
      nerd-fonts.symbols-only
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Inter Variable" "Liberation Serif"];
        sansSerif = ["Inter Variable" "Liberation Sans"];
        monospace = ["0xProto Nerd Font Mono" "Liberation Mono"];
      };
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.package = pkgs.lix;

  programs.command-not-found.enable = false;
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          lz4
          zstd
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
          gamescope
        ];
    };
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
    };
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
    Defaults timestamp_timeout=60
  '';

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # open = lib.mkOverride 990 (nvidiaPackage ? open && nvidiaPackage ? firmware);
    open = true;
    # nvidiaSettings = false;

    # prime = {
    #   intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:1:0:0";
    #
    #   # Needed for finegrained power management to work
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };
    # };

    # modesetting.enable = true;

    # Causes sleep and suspend to fail.
    # powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    # nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  systemd = {
    # Workaround for bugged touchpad
    # services = {
    #   reload-touchpad = {
    #     script = "/home/lippiece/bin/reload-touchpad.fish";
    #     serviceConfig = {
    #       Type = "simple";
    #     };
    #   };
    # };
    #
    # timers = {
    #   reload-touchpad = {
    #     wantedBy = ["timers.target"];
    #     timerConfig = {
    #       OnUnitInactiveSec = "5m";
    #       Unit = "reload-touchpad.service";
    #     };
    #   };
    # };
  };
}
