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
    kernelParams = ["psmouse.synaptics_intertouch=0" "i8042.noloop" "i8042.nomux" "i8042.nopnp" "i8042.reset"];
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
    touchpad = {
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
    btop
    unzip
    tree
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
    inotify-tools
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
  # programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  # glib
  # glibc
  # nss
  # nspr
  # atk
  # cups
  # dbus
  # libdrm
  # gtk3
  # pango
  # cairo
  # xorg.libX11
  # xorg.libXcomposite
  # xorg.libXdamage
  # xorg.libXext
  # xorg.libXfixes
  # xorg.libXrandr
  # libxkbcommon
  # mesa
  # expat
  # xorg.libxcb
  # alsa-lib
  # libGL
  # libsecret
  # ];
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  programs.lazygit = {
    enable = true;
    package = pkgs.buildGoModule rec {
      pname = "lazygit";
      version = "unstable-2025-05-07";
      src = pkgs.fetchFromGitHub {
        owner = "jesseduffield";
        repo = "lazygit";
        rev = "e6bd9d0ae6dd30d04dfe77d2cac15ac54fa18ff6";
        sha256 = "0llb5izpk65nr8qphy556c43w6n162f9pnislxswfmcfdqvcyq60";
      };
      vendorHash = null;
      doCheck = false;
      ldflags = ["-X main.version=${version}" "-X main.buildSource=nix"];
      meta = with pkgs.lib; {
        description = "Simple terminal UI for git commands";
        homepage = "https://github.com/jesseduffield/lazygit";
        license = licenses.mit;
        mainProgram = "lazygit";
      };
    };
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "weekly";
    flake = /home/lippiece/.config/nixos;
  };
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.npm.enable = true;
  programs.dconf.enable = true;
  # programs.java.enable = true;
  # programs.chromium.enablePlasmaBrowserIntegration = true;
  programs.firefox.nativeMessagingHosts.packages = with pkgs; [kdePackages.plasma-browser-integration];
  programs.kde-pim = {
    enable = true;
    kontact = true;
  };
  programs.msmtp = {
    enable = true;

    accounts = {
      ${mail} = {
        auth = true;
        tls = true;
        # try setting `tls_starttls` to `false` if sendmail hangs
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
  # system.copySystemConfiguration = true;

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
    extraLocaleSettings = {
      LC_TIME = "en_GB.utf8";
    };
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
      };
    };
    enableDefaultPackages = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.package = pkgs.lix;
  nix.nixPath = ["/home/lippiece/.config/nixos/"];

  programs.command-not-found.enable = false;
  programs.steam = {
    enable = true;
    # package = pkgs.steam.override {
    #   extraPkgs = pkgs:
    #     with pkgs; [
    #       lz4
    #       zstd
    #       xorg.libXcursor
    #       xorg.libXi
    #       xorg.libXinerama
    #       xorg.libXScrnSaver
    #       libpng
    #       libpulseaudio
    #       libvorbis
    #       stdenv.cc.cc.lib
    #       libkrb5
    #       keyutils
    #       gamescope
    #     ];
    # };
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
    Defaults timestamp_timeout=1800
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
}
