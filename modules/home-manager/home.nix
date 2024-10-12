{
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lippiece";
  home.homeDirectory = "/home/lippiece";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    ####################################
    #              GUI
    ####################################

    # Tools
    kdePackages.kclock
    telegram-desktop
    # vivaldi
    # (vivaldi.override {isSnapshot = true;})
    (vivaldi.overrideAttrs (oldAttrs: {
      dontWrapQtApps = false;
      dontPatchELF = true;
      nativeBuildInputs =
        oldAttrs.nativeBuildInputs
        ++ [pkgs.kdePackages.wrapQtAppsHook];
    }))

    # Work
    super-productivity
    onlyoffice-bin

    # Entertainment
    webtorrent_desktop
    qbittorrent-enhanced
    spotube
    bottles

    ####################################
    #             CLI
    ####################################

    # vim
    neovim
    vimPlugins.LazyVim
    neovide

    # Shell
    nushell
    cht-sh
    imagemagick
    wl-clipboard
    pass-git-helper
    proxychains-ng
    commitizen

    # Nix
    alejandra
    nixfmt-classic

    # Mutt
    mutt-wizard
    neomutt
    isync
    urlscan
    msmtp
    lynx

    # Rust
    rustc
    rustup

    # Scala
    # coursier
    # scala
    # scala-cli
    # scalafmt
    # metals
    # sbt
    # ammonite
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/BraveSoftware/Brave-Browser/NativeMessagingHosts/".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/";

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lippiece/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.chromium = {
    enable = true;
    # defaultSearchProviderSearchURL = "https://lipsearch.ydns.eu/search?q=%";
    # defaultSearchProviderEnabled = true;
    package = pkgs.ungoogled-chromium;
  };
  programs.dircolors.enable = true;
  programs.eza.enable = true;
  programs.eza.icons = true;
  programs.fd.enable = true;
  programs.fd.hidden = true;
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "done";
        # TODO: expipiplus1/update-nix-fetchgit
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
          hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "44c521ab292f0eb659a9e2e1b6f83f5f0595fcbd";
          hash = "sha256-85iU1QzcZmZYGhK30/ZaKwJNLTsx+j3w6St8bFiQWxc=";
        };
      }
    ];
  };
  programs.git = {
    enable = true;
    # delta.enable = true;
    diff-so-fancy.enable = true;
    diff-so-fancy.changeHunkIndicators = true;
    # signing.signByDefault = true;
    userEmail = "github@lippiece.anonaddy.me";
    userName = "lippiece";
  };
  programs.zoxide.enable = true;
  # programs.thunderbird = {
  #   enable = true;
  #   package = pkgs.thunderbirdPackages.thunderbird-128;
  # };
  programs.tealdeer.enable = true;
  programs.password-store = {enable = true;};
  programs.nix-index.enable = true;
  programs.newsboat = {
    enable = true;
    extraConfig = "\n      reload-threads 5\n      auto-reload yes\n      reload-time 120\n      reload-threads 4\n      download-retries 4\n      download-timeout 10\n      prepopulate-query-feeds yes\n\n      # -- display -------------------------------------------------------------------\n      color info default default reverse\n      color listnormal_unread yellow default\n      color listfocus blue default reverse bold\n      color listfocus_unread blue default reverse bold\n\n      text-width 80\n\n      # -- navigation ----------------------------------------------------------------\n\n      goto-next-feed no\n\n      bind-key j down feedlist\n      bind-key k up feedlist\n      bind-key j next articlelist\n      bind-key k prev articlelist\n      bind-key J next-feed articlelist\n      bind-key K prev-feed articlelist\n      bind-key j down article\n      bind-key k up article\n      ";
    urls = [
      {url = "https://dotfyle.com/this-week-in-neovim/rss.xml";}
      {url = "https://factorio.com/blog/rss";}
      {
        url = "https://habr.com/ru/rss/feed/d6e1aa020767fe5324b423fc403b5751?fl=en%2Cru&rating=25&types%5B%5D=article&types%5B%5D=post";
      }
      {url = "https://bun.sh/rss.xml";}
      {url = "https://kde.org/index.xml";}
      {url = "http://cumulonimbus:4002/rss/test";}
    ];
  };
  programs.neomutt = {enable = true;};
  programs.carapace.enable = true;
  programs.gpg.enable = true;
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [tmuxPlugins.resurrect];
    newSession = true;
  };

  # systemd.user.services = {
  #   mailsync = {
  #     enable = true;
  #     after = [ "network.target" ];
  #     wantedBy = [ "default.target" ];
  #     description = "Sync mail";
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = ''/my/cool/user/service'';
  #     };
  #   };
  # };
  # systemd.user.timers = {
  #   mailsync = {
  #     wantedBy = [ "timers.target" ];
  #     timerConfig = {
  #       OnBootSec = "5m";
  #       OnUnitActiveSec = "5m";
  #       Unit = "mailsync.service";
  #     };
  #   };
  # };
  services.easyeffects.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "vivaldi"
    ];
}
