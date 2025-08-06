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
  home.username = "${main.name}";
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

    # # Emulators
    # Laggy and can't redirect USB
    # spice-gtk
    # quickemu
    # spice-vdagent

    # # Plasma
    geoclue2

    # # Work
    super-productivity
    onlyoffice-bin

    # # Entertainment
    webtorrent_desktop
    qbittorrent-enhanced
    (bottles.override {
      removeWarningPopup = true;
    })
    variety
    prismlauncher
    rimsort

    #################################
    #              CLI              #
    #################################

    # # vim
    neovim
    neovide
    fzf
    lua54Packages.luarocks
    gnumake
    python312Packages.pip
    python3Full
    python312Packages.venvShellHook
    uv

    # # Shell
    bun
    so
    imagemagick
    wl-clipboard
    pass-git-helper
    proxychains-ng
    commitizen
    gh
    python313Packages.subliminal
    steamcmd

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
            rev = "0bfe402753681f705a482694fcaf20c2bfc6deb7";
            sha256 = "0snjrqwa5ajv5fsx7sjx9lvpsclxdr0fbd43jr479ff1nc3863jq";
          };
        }
        {
          name = "puffer-fish";
          src = pkgs.fetchFromGitHub {
            owner = "nickeb96";
            repo = "puffer-fish";
            rev = "12d062eae0ad24f4ec20593be845ac30cd4b5923";
            sha256 = "06g8pv68b0vyhhqzj469i9rcics67cq1kbhb8946azjb8f7rhy6s";
          };
        }
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "7318d44a4b367c396d2bbaab90836d5107804792";
            sha256 = "1c04sf8sy3acipvprmaxm82jsh02cq7d4l3ww9snmaapm1i3bs81";
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
        {url = "https://www.brycewray.com/index-excerpts.xml";}
        {url = "https://eslint.org/feed.xml";}
      ];
    };

    neomutt = {
      enable = true;
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

        # mutt-wizard
        source ${pkgs.mutt-wizard}/share/mutt-wizard/mutt-wizard.muttrc

        macro index,pager gi "<change-folder>=Inbox<enter>" "go to inbox"
        macro index,pager Mi ";<save-message>=Inbox<enter>" "move mail to inbox"
        macro index,pager Ci ";<copy-message>=Inbox<enter>" "copy mail to inbox"

        # unbind index <return>
        bind index <return> display-message

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

  programs.command-not-found.enable = false;
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

      # In vi copy mode, press 'y' to copy but remain in copy-mode
      bind -T copy-mode-vi y send -X copy-selection

      # `open` the selected text
      bind -T copy-mode-vi o send-keys -X copy-pipe-and-cancel "xargs open"
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
        sendMailCommand = "msmtpq -a ${main.mail}";
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
        sendMailCommand = "msmtpq -a ${DW.mail}";
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
      "obsidian"
      "steam"
      "steamcmd"
      "steam-unwrapped"
      "rimsort"
      "steamworkspy"
    ];

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
  # gtk.cursorTheme.name	The name of the cursor theme within the package.	string
  # gtk.cursorTheme.package	Package providing the cursor theme. This package will be installed to your profile. If `null` then the cursor theme is assumed to already be available in your profile. 	null or package
  # gtk.cursorTheme.size	The size of the cursor.	null or signed integer
  # gtk.cursorTheme	Default cursor theme for all GTK versions.	null or (submodule)
  # gtk.enable	Whether to enable GTK theming and configuration.	boolean
  # gtk.font.name	The family name of the font within the package. 	string
  # gtk.font.package	Package providing the font. This package will be installed to your profile. If `null` then the font is assumed to already be available in your profile. 	null or package
  # gtk.font.size	The size of the font. 	null or signed integer or floating point number
  # gtk.font	Default font for all GTK versions.	null or (submodule)
  # gtk.gtk2.configLocation	The location of the GTK 2 configuration file.	absolute path
  # gtk.gtk2.cursorTheme.name	The name of the cursor theme within the package.	string
  # gtk.gtk2.cursorTheme.package	Package providing the cursor theme. This package will be installed to your profile. If `null` then the cursor theme is assumed to already be available in your profile. 	null or package
  # gtk.gtk2.cursorTheme.size	The size of the cursor.	null or signed integer
  # gtk.gtk2.cursorTheme	Cursor theme for GTK 2 applications.	null or (submodule)
  # gtk.gtk2.enable	Whether to enable GTK 2 configuration.	boolean
  # gtk.gtk2.extraConfig	Extra lines to add to {file}`~/.gtkrc-2.0`.	strings concatenated with "\n"
  # gtk.gtk2.font.name	The family name of the font within the package. 	string
  # gtk.gtk2.font.package	Package providing the font. This package will be installed to your profile. If `null` then the font is assumed to already be available in your profile. 	null or package
  # gtk.gtk2.font.size	The size of the font. 	null or signed integer or floating point number
  # gtk.gtk2.font	Font for GTK 2 applications.	null or (submodule)
  # gtk.gtk2.force	Whether to enable GTK 2 config force overwrite without creating a backup.	boolean
  # gtk.gtk2.iconTheme.name	The name of the icon theme within the package.	string
  # gtk.gtk2.iconTheme.package	Package providing the icon theme. This package will be installed to your profile. If `null` then the icon theme is assumed to already be available in your profile. 	null or package
  # gtk.gtk2.iconTheme	Icon theme for GTK 2 applications.	null or (submodule)
  # gtk.gtk2.theme.name	The name of the theme within the package.	string
  # gtk.gtk2.theme.package	Package providing the theme. This package will be installed to your profile. If `null` then the theme is assumed to already be available in your profile. For the theme to apply to GTK 4, this option is mandatory. 	null or package
  # gtk.gtk2.theme	Theme for GTK 2 applications.	null or (submodule)
  # gtk.gtk3.bookmarks	File browser bookmarks.	list of string
  # gtk.gtk3.cursorTheme.name	The name of the cursor theme within the package.	string
  # gtk.gtk3.cursorTheme.package	Package providing the cursor theme. This package will be installed to your profile. If `null` then the cursor theme is assumed to already be available in your profile. 	null or package
  # gtk.gtk3.cursorTheme.size	The size of the cursor.	null or signed integer
  # gtk.gtk3.cursorTheme	Cursor theme for GTK 3 applications.	null or (submodule)
  # gtk.gtk3.enable	Whether to enable GTK 3 configuration.	boolean
  # gtk.gtk3.extraConfig	Extra settings for {file}`$XDG_CONFIG_HOME/gtk-3.0/settings.ini`.	attribute set of (boolean or signed integer or string)
  # gtk.gtk3.extraCss	Extra CSS for {file}`$XDG_CONFIG_HOME/gtk-3.0/gtk.css`.	strings concatenated with "\n"
  # gtk.gtk3.font.name	The family name of the font within the package. 	string
  # gtk.gtk3.font.package	Package providing the font. This package will be installed to your profile. If `null` then the font is assumed to already be available in your profile. 	null or package
  # gtk.gtk3.font.size	The size of the font. 	null or signed integer or floating point number
  # gtk.gtk3.font	Font for GTK 3 applications.	null or (submodule)
  # gtk.gtk3.iconTheme.name	The name of the icon theme within the package.	string
  # gtk.gtk3.iconTheme.package	Package providing the icon theme. This package will be installed to your profile. If `null` then the icon theme is assumed to already be available in your profile. 	null or package
  # gtk.gtk3.iconTheme	Icon theme for GTK 3 applications.	null or (submodule)
  # gtk.gtk3.theme.name	The name of the theme within the package.	string
  # gtk.gtk3.theme.package	Package providing the theme. This package will be installed to your profile. If `null` then the theme is assumed to already be available in your profile. For the theme to apply to GTK 4, this option is mandatory. 	null or package
  # gtk.gtk3.theme	Theme for GTK 3 applications.	null or (submodule)
  # gtk.gtk4.cursorTheme.name	The name of the cursor theme within the package.	string
  # gtk.gtk4.cursorTheme.package	Package providing the cursor theme. This package will be installed to your profile. If `null` then the cursor theme is assumed to already be available in your profile. 	null or package
  # gtk.gtk4.cursorTheme.size	The size of the cursor.	null or signed integer
  # gtk.gtk4.cursorTheme	Cursor theme for GTK 4 applications.	null or (submodule)
  # gtk.gtk4.enable	Whether to enable GTK 4 configuration.	boolean
  # gtk.gtk4.extraConfig	Extra settings for {file}`$XDG_CONFIG_HOME/gtk-4.0/settings.ini`.	attribute set of (boolean or signed integer or string)
  # gtk.gtk4.extraCss	Extra CSS for {file}`$XDG_CONFIG_HOME/gtk-4.0/gtk.css`.	strings concatenated with "\n"
  # gtk.gtk4.font.name	The family name of the font within the package. 	string
  # gtk.gtk4.font.package	Package providing the font. This package will be installed to your profile. If `null` then the font is assumed to already be available in your profile. 	null or package
  # gtk.gtk4.font.size	The size of the font. 	null or signed integer or floating point number
  # gtk.gtk4.font	Font for GTK 4 applications.	null or (submodule)
  # gtk.gtk4.iconTheme.name	The name of the icon theme within the package.	string
  # gtk.gtk4.iconTheme.package	Package providing the icon theme. This package will be installed to your profile. If `null` then the icon theme is assumed to already be available in your profile. 	null or package
  # gtk.gtk4.iconTheme	Icon theme for GTK 4 applications.	null or (submodule)
  # gtk.gtk4.theme.name	The name of the theme within the package.	string
  # gtk.gtk4.theme.package	Package providing the theme. This package will be installed to your profile. If `null` then the theme is assumed to already be available in your profile. For the theme to apply to GTK 4, this option is mandatory. 	null or package
  # gtk.gtk4.theme	Theme for GTK 4 applications.	null or (submodule)
  # gtk.iconTheme.name	The name of the icon theme within the package.	string
  # gtk.iconTheme.package	Package providing the icon theme. This package will be installed to your profile. If `null` then the icon theme is assumed to already be available in your profile. 	null or package
  # gtk.iconTheme	Default icon theme for all GTK versions.	null or (submodule)
  # gtk.theme.name	The name of the theme within the package.	string
  # gtk.theme.package	Package providing the theme. This package will be installed to your profile. If `null` then the theme is assumed to already be available in your profile. For the theme to apply to GTK 4, this option is mandatory. 	null or package
  # gtk.theme	Default theme for all GTK versions.	null or (submodule)

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
