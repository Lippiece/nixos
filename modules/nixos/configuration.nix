# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useUserPackages = true;

    users.lippiece = ../home-manager/home.nix;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
    };
    kernel.sysctl = {
      "vm.overcommit_memory" = 1;
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking = {
    hostName = "cumulonimbus"; # Define your hostname.

    firewall.enable = false;

    networkmanager.enable =
      true; # Easiest to use and most distros use this by default.
    # If using NetworkManager:
    networkmanager.dns = "systemd-resolved";
    # networkmanager.dns = "none";
    # nameservers = ["127.0.0.1"];

    useDHCP = lib.mkDefault true;
    enableIPv6 = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Kaliningrad";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    extraLocales = ["ru_RU.UTF-8/UTF-8"];
    defaultLocale = "en_GB.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lippiece = {
    isNormalUser = true;
    packages = with pkgs; [
      tree
    ];
    initialPassword = "9985";
  };
  users.defaultUserShell = pkgs.fish;
  users.mutableUsers = false;

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
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
    };
    nix-ld.enable = true;
    lazygit = {
      enable = true;
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
    command-not-found.enable = false;
  };

  environment = {
    sessionVariables = {
      PAGER = "nvim -R";
      MANPAGER = "nvim +Man!";
    };
    systemPackages = with pkgs; [
      # Essential
      wget
      bat
      unar
      git
      silver-searcher
      vlc
      btop
      # TODO: build failure
      # glances
      unzip
      tree
    ];
  };

  system = {
    # autoUpgrade = {
    #   flake = inputs.self.outPath;
    #   flags = [
    #     "--upgrade-all"
    #     "--print-build-logs"
    #     "--commit-lock-file"
    #   ];
    #   dates = "weekly";
    #   operation = "switch";
    #   persistent = true;
    #   enable = true;
    # };

    # Most users should NEVER change this value after the initial install, for any reason,
    stateVersion = "25.11"; # Did you read the comment?
  };

  security = {
    pam.loginLimits = [
      {
        domain = "@users";
        type = "soft";
        item = "priority";
        value = "1";
      }
    ];
    sudo.extraConfig = ''
      Defaults timestamp_timeout=7200
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    # dnsproxy = {
    #   enable = true;
    #   settings = {
    #     bootstrap = ["9.9.9.9:53"];
    #
    #     # Plain DNS upstream
    #     # upstream = [ "1.1.1.1:53" ];
    #     # DNS over TLS upstream
    #     # upstream = [ "tls://dns.adguard.com" ];
    #     # DNS over HTTPS upstream
    #     upstream = ["9.9.9.9:53"];
    #     # upstream = ["quic://lipguard.ydns.eu"];
    #   };
    #   # Additional launch flags
    #   # flags = [ "--verbose" ];
    # };

    btrfs.autoScrub.enable = true;

    beesd.filesystems = {
      root = {
        spec = "/";
        hashTableSizeMB = 512;
        verbosity = "crit";
        extraOptions = ["--loadavg-target" "5.0"];
      };
    };

    resolved = {
      enable = true;
      fallbackDns = [
        "9.9.9.9"
      ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };
}
