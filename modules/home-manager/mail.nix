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
  home.packages = with pkgs; [
    sequoia-sq
  ];

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
      application/pgp-encrypted; ${lib.getExe pkgs.sequoia-sq} decrypt '%s'; copiousoutput;
      application/pgp-keys; ${lib.getExe pkgs.sequoia-sq} key import '%s'; copiousoutput;
    '';
  };
  programs = {
    notmuch.enable = true;
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

        # Sequoia instad of GPG
        set pgp_check_gpg_decrypt_status_fd = no
        set pgp_use_gpg_agent = yes
        set crypt_use_gpgme = no

        # Encryption and signing
        # verifying cleartext, decrypting messages and analyzing public keys, for
        # application/pgp types.
        set pgp_decode_command="${lib.getExe pkgs.sequoia-chameleon-gnupg} --status-fd=2 %?p?--passphrase-fd 0 --pinentry-mode=loopback? --no-verbose --quiet --batch --output - %f"
        set pgp_verify_command="${lib.getExe pkgs.sequoia-sq} verify --signature-file %s -- %f"
        set pgp_sign_command="${lib.getExe pkgs.sequoia-sq} sign %?a?--signer %a? --mode text --signature-file - -- %f"
        set pgp_clearsign_command="${lib.getExe pkgs.sequoia-sq} sign %?a?--signer %a? --cleartext -- %f"
        set pgp_decrypt_command="${lib.getExe pkgs.sequoia-sq} decrypt --signatures 0 %f"

        set pgp_encrypt_only_command="${lib.getExe pkgs.sequoia-sq} encrypt --without-signature --for %r --for-email ${main.mail} -- %f"
        set pgp_encrypt_sign_command="${lib.getExe pkgs.sequoia-sq} encrypt --signer-email ${main.mail} --for %r --for-email ${main.mail} -- %f"

        # Keyring management
        set pgp_import_command="${lib.getExe pkgs.sequoia-sq} cert import -- %f"
        set pgp_export_command="${lib.getExe pkgs.sequoia-sq} cert export --cert %r"
        # Note: Disabled by default as the search can take some time.
        # set pgp_getkeys_command="${lib.getExe pkgs.sequoia-sq} network search --batch --quiet -- %r"
        set pgp_verify_key_command="${lib.getExe pkgs.sequoia-sq} pki identify --cert %r 2>&1"
        # Note: the second --with-fingerprint adds fingerprints to subkeys
        set pgp_list_pubring_command="${lib.getExe pkgs.sequoia-chameleon-gnupg} --no-verbose --quiet --with-colons --with-fingerprint --with-fingerprint --list-keys %r"
        set pgp_list_secring_command="${lib.getExe pkgs.sequoia-chameleon-gnupg} --no-verbose --quiet --with-colons --with-fingerprint --with-fingerprint --list-secret-keys %r"

        set pgp_good_sign="^[[:space:]]*Good signature from "
        set pgp_decryption_okay="Decrypted by"
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
}
