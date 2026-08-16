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
    smtpport = 465;
    imapport = 993;
  };

  sq = lib.getExe pkgs.sequoia-sq;
in {
  home.packages = with pkgs; [
    sequoia-sq
    sequoia-chameleon-gnupg
    libsecret
  ];

  accounts.email = {
    accounts.${main.mail} = {
      passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup mail ${main.mail}";

      primary = true;
      realName = "${main.name}";
      address = "${main.mail}";
      userName = "${main.name}";

      aerc = {
        enable = true;
        extraAccounts = {
          source = "notmuch://";
        };
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

      imapnotify = {
        enable = true;
        boxes = [
          "Inbox"
        ];
        extraConfig = {
          onNewMail = "${pkgs.writeShellScript "onNewMail" ''
            ${pkgs.isync}/bin/mbsync ${main.mail}
            ${lib.getExe pkgs.notmuch} new
            ${lib.getExe pkgs.libnotify} 'Mail'
          ''}";
        };
      };
    };
  };
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
      application/pgp-encrypted; ${sq} decrypt '%s'; copiousoutput;
      application/pgp-keys; ${sq} key import '%s'; copiousoutput;
    '';
  };
  programs = {
    notmuch.enable = true;
    mbsync = {
      enable = true;
      groups = {
        inboxes = {
          ${main.mail} = ["Inbox"];
        };
      };
    };
    aerc = {
      enable = true;
      extraConfig = {
        filters = {
          "text/plain" = "colorize";
          "text/html" = "html";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          ".headers" = "colorize";
          "text/calendar" = "calendar";
        };
        ui = {
          "styleset-name" = "nord";
          "fuzzy-complete" = "true";
          "icon-new" = "✨";
          "icon-attachment" = "📎";
          "icon-old" = "🕰️";
          "icon-replied" = "📝";
          "icon-flagged" = "🚩";
          "icon-deleted" = "🗑️";
          "icon-draft " = "🧾";
          "icon-encrypted " = "🔒";
          "icon-signed " = "🔑";
          "icon-signed-encrypted " = "🔐";
          "icon-unknown " = "❔";
          "icon-invalid " = "❗";
          "icon-forwarded " = "📨";
          "threading-enabled " = "true";
          "threading-by-subject " = "true";
          "show-thread-context " = "true";
          "msglist-scroll-offset " = "5";
          "thread-prefix-tip " = "";
          "thread-prefix-indent " = "";
          "thread-prefix-stem " = "│";
          "thread-prefix-limb " = "─";
          "thread-prefix-folded " = "+";
          "thread-prefix-unfolded " = "";
          "thread-prefix-first-child " = "┬";
          "thread-prefix-has-siblings " = "├";
          "thread-prefix-orphan " = "┌";
          "thread-prefix-dummy " = "┬";
          "thread-prefix-lone " = "";
          "thread-prefix-last-sibling " = "╰";
          "timestamp-format " = "02.01.2006";
          "this-day-time-format " = "3:04 PM";
          "this-week-time-format " = "Mon 02.01";
          "this-year-time-format " = "02.01";
          "message-view-timestamp-format " = "02.01.2006, 3:04 PM GMT-0700";
        };
        general = {
          unsafe-accounts-conf = true;
        };
        statusline = {display-mode = "icon";};
      };
    };
  };
  systemd = {
    user.services = {
      mailsync = {
        Unit = {
          Description = "Sync mail";
        };

        Service = {
          Type = "oneshot";
          ExecStart = "/home/lippiece/bin/check-mail.fish";
        };

        Install = {
          WantedBy = ["network.target"];
        };
      };

      krunner-daemon = {
        Unit = {
          Description = "Run krunner daemon";
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/krunner -d";
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

      clear-notifications = {
        Unit = {
          Description = "Clear KDE notifications";
        };

        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.bash} /home/lippiece/bin/clear_notifications.sh";
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

      clear-notifications = {
        Timer = {
          OnBootSec = "15m";
          OnUnitActiveSec = "15m";
        };

        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };

  services = {
    imapnotify.enable = true;
  };
}
