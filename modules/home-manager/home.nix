{
  pkgs,
  lib,
  ...
}: let
  main = {
    mail = "lippiece@vivaldi.net";
    name = "lippiece";
    smtphost = "smtp.vivaldi.net";
    imaphost = "imap.vivaldi.net";
    smtpport = 456;
    imapport = 993;
  };

  DW = {
    mail = "a.anisko@ddemo.ru";
    name = "a.anisko@ddemo.ru";
    smtphost = "smtp.dw.team";
    imaphost = "imap.dw.team";
    smtpport = 465;
    imapport = 993;
  };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${main.name}";
  home.homeDirectory = "/home/lippiece";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

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

    #################################
    #              GUI              #
    #################################

    # # Tools
    kdePackages.kclock
    telegram-desktop
    # vivaldi
    # (vivaldi.override {isSnapshot = true;})
    # (vivaldi.overrideAttrs (oldAttrs: {
    #   isSnapshot = true;
    #   dontWrapQtApps = false;
    #   dontPatchELF = true;
    #   nativeBuildInputs =
    #     oldAttrs.nativeBuildInputs
    #     ++ [pkgs.kdePackages.wrapQtAppsHook];
    # }))
    # brave
    hiddify-app
    obsidian
    (qt6Packages.callPackage ../../packages/mpc-qt/mpc-qt.nix {})

    # # Plasma
    kdePackages.qtstyleplugin-kvantum
    themechanger
    geoclue2
    lightly-qt

    # # Work
    super-productivity
    onlyoffice-bin

    # # Entertainment
    webtorrent_desktop
    qbittorrent-enhanced
    # spotube
    bottles
    variety

    #################################
    #              CLI              #
    #################################

    # # vim
    neovim
    vimPlugins.LazyVim
    neovide
    fzf
    lua54Packages.luarocks
    gnumake
    python312Packages.pip
    python3Full
    python312Packages.venvShellHook

    # # Shell
    # NOTE: often gives 404
    # cht-sh

    # Stackoverflow search
    so
    imagemagick
    wl-clipboard
    pass-git-helper
    proxychains-ng
    commitizen
    gh
    python313Packages.subliminal

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

    # # Scala
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
    # ".config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    ".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    ".zen/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".mailcap".text = ''
      audio/*; xdg-open %s

      image/*; xdg-open %s

      application/msword; xdg-open %s
      application/postscript ; xdg-open %s

      application/x-gunzip; xdg-open %s
      application/x-tar-gz; xdg-open %s

      text/plain; $EDITOR %s ;
      text/html; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ; nametemplate=%s.html
      text/html; lynx -assume_charset=%{charset} -display_charset=utf-8 -dump -width=1024 %s; nametemplate=%s.html; copiousoutput;
      image/*; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ;
      video/*; setsid mpv --quiet %s &; copiousoutput
      audio/*; vlc %s ;
      application/pdf; ${pkgs.mutt-wizard}/lib/mutt-wizard/openfile %s ;
      application/pgp-encrypted; gpg -d '%s'; copiousoutput;
      application/pgp-keys; gpg --import '%s'; copiousoutput;
    '';
  };
  home.shell = {
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    bat.enable = true;

    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };

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
      plugins = [
        {
          name = "done";
          src = pkgs.fetchFromGitHub {
            owner = "franciscolourenco";
            repo = "done";
            rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
            sha256 = "12l7m08bp8vfhl8dmi0bfpvx86i344zbg03v2bc7wfhm20li3hhc";
          };
        }
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "44c521ab292f0eb659a9e2e1b6f83f5f0595fcbd";
            sha256 = "05svj1c6qz1bx7q3vyii7cnls0ibbbvd7dqj39c6crnw1kar967k";
          };
        }
      ];
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
      userName = "${main.name}";
    };

    tealdeer.enable = true;

    password-store = {
      enable = true;
    };

    nix-index.enable = true;

    newsboat = {
      enable = true;
      extraConfig = "\n      reload-threads 5\n      auto-reload yes\n      reload-time 120\n      reload-threads 4\n      download-retries 4\n      download-timeout 10\n      prepopulate-query-feeds yes\n\n      # -- display -------------------------------------------------------------------\n      color info default default reverse\n      color listnormal_unread yellow default\n      color listfocus blue default reverse bold\n      color listfocus_unread blue default reverse bold\n\n      text-width 80\n\n      # -- navigation ----------------------------------------------------------------\n\n      goto-next-feed no\n\n      bind-key j down feedlist\n      bind-key k up feedlist\n      bind-key j next articlelist\n      bind-key k prev articlelist\n      bind-key J next-feed articlelist\n      bind-key K prev-feed articlelist\n      bind-key j down article\n      bind-key k up article\n      ";
      urls = [
        {url = "https://dotfyle.com/this-week-in-neovim/rss.xml";}
        {url = "https://factorio.com/blog/rss";}
        {url = "https://habr.com/ru/rss/feed/d6e1aa020767fe5324b423fc403b5751?fl=en%2Cru&rating=25&types%5B%5D=article&types%5B%5D=post";}
        {url = "https://bun.sh/rss.xml";}
        {url = "https://kde.org/index.xml";}
        # {url = "http://cumulonimbus:4002/rss/test";}
        {url = "https://www.joshwcomeau.com/rss.xml/";}
        {url = "https://astro.build/rss.xml";}
        {url = "https://marvinh.dev/feed.xml";}
      ];
    };

    neomutt = {
      enable = true;
      vimKeys = true;
      extraConfig = ''
        unauto_view "*"

        # Quote
        color body brightcyan default "^[>].*"

        # Link
        color body brightyellow default "(https?|ftp)://[^ ]+"

        # Code block start and end
        color body cyan default "^\`\`\`.*$"

        # mail address
        color body yellow default "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"

        # Patch mail highlight, copied from https://github.com/neomutt/dyk/issues/13
        # Diff changes
        color body brightgreen default "^[+].*"
        color body brightred   default "^[-].*"

        # Diff file
        color body green       default "^[-][-][-] .*"
        color body green       default "^[+][+][+] .*"

        # Diff header
        color body green       default "^diff .*"
        color body green       default "^index .*"

        # Diff chunk
        color body cyan        default "^@@ .*"

        # Linked issue
        color body brightgreen default "^(close[ds]*|fix(e[ds])*|resolve[sd]*):* *#[0-9]+$"

        # Credit
        color body brightwhite default "(signed-off|co-authored)-by: .*"
        # mutt-wizard pre-fixes
        # bind index,pager gT noop
        # bind index dT noop

        # mutt-wizard
        source ${pkgs.mutt-wizard}/share/mutt-wizard/mutt-wizard.muttrc

        # mutt-wizard fixes
        macro index,pager gi "<change-folder>=Inbox<enter>" "go to inbox"
        macro index,pager Mi ";<save-message>=Inbox<enter>" "move mail to inbox"
        macro index,pager Ci ";<copy-message>=Inbox<enter>" "copy mail to inbox"

        unbind index <return>
        bind index <return> dispay-message

        # My additions
        macro index,pager Ml ";<save-message>=Later<enter>" "move mail to later"
        macro index,pager gl "<change-folder>=Later<enter>" "go to Later folder"

        macro index,pager,attach,compose \cb "\
        <enter-command> set my_pipe_decode=\$pipe_decode pipe_decode<Enter>\
        <pipe-message> urlscan<Enter>\
        <enter-command> set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<Enter>" \
        "call urlscan to extract URLs out of a message"

        macro index,pager i1 '<sync-mailbox><enter-command>source /home/lippiece/.config/neomutt/${main.mail}<enter><change-folder>!<enter>;<check-stats>' "switch to ${main.mail}"
        macro index,pager i2 '<sync-mailbox><enter-command>source /home/lippiece/.config/neomutt/${DW.mail}<enter><change-folder>!<enter>;<check-stats>' "switch to ${DW.mail}"

      '';
    };
    mbsync = {
      enable = true;
      groups = {
        inboxes = {
          ${main.mail} = ["Inbox"];
          ${DW.mail} = ["Inbox"];
        };
      };
    };
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  programs.gpg.enable = true;
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [tmuxPlugins.resurrect];
    newSession = true;
    keyMode = "vi";
    extraConfig = ''
      bind c new-window -c "#{pane_current_path}"

      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      bind "\%" split-window -h -c "#{pane_current_path}"
      bind '\"' split-window -c "#{pane_current_path}"
    '';
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  programs.alacritty = {
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
    };
  };
  programs.notmuch.enable = true;

  services = {
    easyeffects.enable = true;
    nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
    kdeconnect.enable = true;
    # gpg-agent = {
    #   enable = true;
    #   enableFishIntegration = true;
    #   enableNushellIntegration = true;
    # };
  };

  accounts.email = {
    accounts.${main.mail} = {
      passwordCommand = "pass ${main.mail}";
      primary = true;
      realName = "${main.name}";
      address = "${main.mail}";
      userName = "${main.name}";
      maildir.path = "${main.mail}";

      neomutt = {
        enable = true;
        mailboxName = "${main.mail}";
      };

      notmuch = {
        enable = true;
      };

      smtp = {
        host = main.smtphost;
        port = main.smtpport;
      };

      imap = {
        host = main.imaphost;
        port = main.imapport;
      };

      msmtp.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
    };

    accounts.${DW.mail} = {
      passwordCommand = "pass ${DW.mail}";
      realName = "${DW.name}";
      address = "${DW.mail}";
      userName = "${DW.name}";
      maildir.path = "${DW.mail}";

      neomutt = {
        enable = true;
        mailboxName = "${DW.mail}";
      };

      notmuch = {
        enable = true;
      };

      smtp = {
        host = DW.smtphost;
        port = DW.smtpport;
      };

      imap = {
        host = DW.imaphost;
        port = DW.imapport;
      };

      msmtp.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
    };
  };

  systemd = {
    user.services = {
      mailsync = {
        Unit = {
          Description = "Sync mail";
          wantedBy = ["network.target"];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "/home/lippiece/bin/check-mail.fish";
        };
      };
    };
    user.timers = {
      mailsync = {
        Unit = {
          Description = "My timer";
          Requires = "mailsync.service";
        };

        Timer = {
          OnBootSec = "5m";
          OnUnitActiveSec = "5m";
          Persist = true;
        };

        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "vivaldi"
      "hiddify-app"
      "hiddify-core"
      "obsidian"
      "steam"
      "steamcmd"
      "rimsort"
    ];

  fonts = {
    fontconfig.enable = true;
  };
}
