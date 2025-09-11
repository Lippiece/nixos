{
  inputs,
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
  imports = [inputs.nixvim.homeModules.nixvim];
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
    element-desktop

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
    (pkgs.callPackage ../../packages/rimsort/package.nix {})

    # # System
    colloid-icon-theme
    colloid-gtk-theme
    kdePackages.karousel

    #################################
    #              CLI              #
    #################################

    # # vim
    neovide
    # neovim
    # fzf
    # lua54Packages.luarocks
    # gnumake
    # python312Packages.pip
    # python3Full
    # python312Packages.venvShellHook
    # uv
    # cargo
    # nodejs
    # ripgrep
    python313Packages.demjson3

    # # Shell
    bun
    so
    imagemagick
    wl-clipboard
    pass-git-helper
    proxychains-ng
    commitizen
    gh
    steamcmd
    rsync

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
      generateCompletions = true;
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
            rev = "7818abcbc600372418b1f8a931306b1d694bd009";
            sha256 = "0zgn0ys34vc6b0hzqack3m6vlz0kad4chmr3zia2lamxjr6y7dxr";
          };
        }
      ];
      interactiveShellInit = ''
        set -U __done_min_cmd_duration 1000
      '';
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

    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      vimdiffAlias = true;

      globals = {
        mapleader = ",";
        maplocalleader = "\\";
      };

      opts = {
        confirm = true;
        cursorline = true;
        expandtab = true;
        ignorecase = true;
        smartcase = true;
        inccommand = "nosplit";
        fillchars = {
          foldopen = "";
          foldclose = "";
          diff = "╱";
        };
        jumpoptions = "view";
        laststatus = 3;
        linebreak = true;
        breakindent = true;
        smartindent = true;
        wrap = true;
        textwidth = 80;
        wrapmargin = 0;
        list = true;
        number = true;
        relativenumber = true;
        pumblend = 10;
        pumheight = 10;
        shiftround = true;
        shiftwidth = 2;
        shortmess = "atToOCF";
        showmode = false;
        signcolumn = "yes";
        splitkeep = "screen";
        tabstop = 2;
        termguicolors = true;
        timeoutlen = 300;
        undofile = true;
        guifont = "0xProto Nerd Font Mono:h10";
        scrolloff = 8;
        langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz";
        foldnestmax = 8;
        foldlevel = 2;
        foldlevelstart = 2;
        # Don't break cli programs' watch mode
        backupcopy = "yes";
        mouse = "";
        conceallevel = 2;
      };

      colorschemes.onedark.enable = true;

      plugins = {
        lspconfig = {
          enable = true;
        };

        blink-cmp = {
          enable = true;
          settings = {
            keymap = {
              "<C-space>" = [
                "show"
                "show_documentation"
                "hide_documentation"
              ];
              "<Tab>" = [
                "select_next"
                "fallback"
              ];
              "<S-Tab>" = [
                "select_prev"
                "fallback"
              ];
              "<C-b>" = [
                "scroll_documentation_up"
                "fallback"
              ];
              "<CR>" = ["accept" "fallback"];
              "<C-f>" = [
                "scroll_documentation_down"
                "fallback"
              ];
            };
            signature = {
              enabled = true;
            };
            completion = {
              list = {
                selection = {
                  auto_insert = false;
                };
                cycle = {
                  from_bottom = true;
                  from_top = true;
                };
              };
              accept = {auto_brackets = {enabled = true;};};
            };
            sources = {
              default = ["lsp" "snippets" "path" "codeium"];
              providers = {
                codeium = {
                  name = "Codeium";
                  module = "codeium.blink";
                  async = true;
                  score_offset = -1;
                };
              };
            };
          };
        };

        neo-tree = {
          enable = true;
        };

        conform-nvim = {
          enable = true;
          settings = {
            formatters = {
              alejandra = {
                command = lib.getExe pkgs.alejandra;
              };
              stylua = {
                command = lib.getExe pkgs.stylua;
              };
              prettier.command = lib.getExe pkgs.prettier;
              yamlfmt.command = lib.getExe pkgs.yamlfmt;
            };
            formatters = {
              oxlint = {
                command = "oxlint";
                args = [
                  "--import-plugin"
                  "--type-aware"
                  "--fix"
                  "--fix-suggestions"
                  "--fix-dangerously"
                  "$FILENAME"
                ];
                exit_codes = [0 2]; # code 2 is given when the file includes some non-autofixable errors
                stdin = false;
                tmpfile_format = "ConformOxlint$FILENAME";
              };
              stylelint = {
                meta = {
                  url = "https://github.com/stylelint/stylelint";
                  description = "A mighty CSS linter that helps you avoid errors and enforce conventions.";
                };
                command = "stylelint";
                args = ["$FILENAME" "--fix"];
                exit_codes = [0 2]; # code 2 is given when the file includes some non-autofixable errors
                stdin = false;
                tmpfile_format = "ConformStylelint$FILENAME";
              };
              biome_check = {
                command = "biome";
                args = [
                  "check"
                  "--write"
                  "--unsafe"
                  "--stdin-file-path"
                  "$FILENAME"
                ];
                stdin = true;
              };
              prettier_custom = {
                command = "prettier";
                args = [
                  "--write"
                  "--stdin-filepath"
                  "$FILENAME"
                ];
                stdin = true;
              };
            };
            formatters_by_ft = {
              # -- ["*"] = { "injected" };
              javascript = ["biome_check" "oxlint" "eslint_d"];
              typescript = ["biome_check" "oxlint" "eslint_d"];
              javascriptreact = ["biome_check" "oxlint" "eslint_d"];
              typescriptreact = ["biome_check" "oxlint" "eslint_d"];
              astro = ["prettier_custom" "biome_check" "oxlint"];
              vue = ["prettier" "biome_check" "oxlint" "eslint_d"];
              svelte = ["prettier" "biome_check" "oxlint" "eslint_d"];
              css = ["prettier"];
              html = ["prettier"];
              json = ["biome_check" "eslint_d"];
              jsonc = ["biome_check" "eslint_d"];
              nix = ["alejandra"];
              lua = ["stylua"];
              # python = ["isort" "black"];
              yaml = ["yamlfmt"];
              # fish = ["fish_indent"];
              # rust = ["rustfmt"];
              injected = {options = {ignore_errors = true;};};
            };
            format_after_save =
              # Lua
              ''
                function()
                  if vim.g.disable_autoformat or vim.b.disable_autoformat then
                    return
                  end

                  return {
                    async = true,
                    ignore_errors = true,
                    lsp_format = "fallback",
                  }
                end
              '';
            log_level = "warn";
            notify_on_error = true;
            notify_no_formatters = true;
          };
        };

        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
            incremental_selection = {
              enable = true;
              keymaps = {
                init_selection = "gnn";
                scope_incremental = false;
                node_incremental = "v";
                node_decremental = "V";
              };
            };
          };
        };

        refactoring = {
          enable = true;
          settings = {
            show_success_message = true;
          };
        };

        auto-session = {
          enable = true;
          settings = {
            suppressed_dirs = ["~/" "~/Projects" "~/Downloads" "/"];
            # Follow normal session save/load logic if launched with a single
            # directory as the only argument
            args_allow_single_directory = false;
            # (30 days) Sessions older than purge_after_minutes will be
            # deleted asynchronously on startup, e.g. set to 14400 to delete
            # sessions that haven't been accessed for more than 10 days,
            # defaults to off (no purging), requires >= nvim 0.10
            purge_after_minutes = 43200;
          };
        };

        fastaction = {
          enable = true;
          settings = {
            title = false;
          };
        };

        windsurf-nvim = {
          enable = true;
          settings.enable_cmp_source = false;
        };

        lint = {
          enable = true;
          lintersByFt = {
            fish = ["fish"];
            json = ["jsonlint" "eslint_d"];
            jsonc = ["jsonlint" "eslint_d"];
            javascript = ["oxlint" "eslint_d"];
            typescript = ["oxlint" "eslint_d"];
            typescriptreact = ["oxlint" "eslint_d"];
            javascriptreact = ["oxlint" "eslint_d"];
            astro = ["oxlint"];
            svelte = ["oxlint" "eslint_d"];
            vue = ["oxlint" "eslint_d"];
            css = ["stylelint"];
            # html = ["markuplint"];
            # -- Use the "*" filetype to run linters on all filetypes.
            # -- '*' = [ 'global linter' ];
            # # -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
            # -- '_' = [ 'fallback linter' ];
            # -- "*" = [ "typos" ];
          };
        };

        noice = {
          enable = true;
          settings = {
            cmdline.enabled = false;
            messages.enabled = false;
            # popupmenu.enabled = false;
          };
        };

        lualine.enable = true;
        lazydev.enable = true;
        lazygit.enable = true;
        schemastore.enable = true;
        sleuth.enable = true;
        todo-comments.enable = true;
        treesitter-refactor.enable = true;
        treesitter-textobjects.enable = true;
        treesj.enable = true;
        trouble.enable = true;
        ts-comments.enable = true;
        web-devicons.enable = true;
        which-key.enable = true;
        actions-preview.enable = true;
        dap.enable = true;
        # TODO: https://github.com/nix-community/nixvim/issues/3654
        # project-nvim.enable = true;
        sandwich.enable = true;
        git-conflict.enable = true;
        ccc.enable = true;
        snacks.enable = true;
        origami.enable = true;
        guess-indent.enable = true;
        bufferline.enable = true;
      };

      extraPlugins = with pkgs; [
        vimPlugins.nvim-unception
        vimPlugins.vim-fetch
        # pkgs.vimPlugins.vim-automkdir
        (vimUtils.buildVimPlugin {
          name = "automkdir";
          src = pkgs.fetchFromGitHub {
            owner = "mateuszwieloch";
            repo = "automkdir.nvim";
            rev = "e36da288764cc41864dc5b4e1234f1425033ce59";
            sha256 = "1qpwip0wd7shry094355ljq7143vlsmkq60pgi0bvdh9dywf21f4";
          };
        })
        (vimUtils.buildVimPlugin {
          name = "ts-error-translator";
          src = pkgs.fetchFromGitHub {
            owner = "dmmulroy";
            repo = "ts-error-translator.nvim";
            rev = "47e5ba89f71b9e6c72eaaaaa519dd59bd6897df4";
            sha256 = "08whn7l75qv5n74cifmnxc0s7n7ja1g7589pjnbbsk2djn6bqbky";
          };
        })
        (vimUtils.buildVimPlugin {
          name = "nvim_context_vt";
          src = pkgs.fetchFromGitHub {
            owner = "andersevenrud";
            repo = "nvim_context_vt";
            rev = "b69f642f7848fec8c056a7e2c9452e3dec84c2b5";
            sha256 = "1dyzp6ng67a6zp021nxbimj7rf7bp7rkc4lkl9wrx9fwvxz1x0xi";
          };
        })
        # TODO: https://github.com/nix-community/nixvim/issues/3654
        (vimUtils.buildVimPlugin {
          name = "project";
          src = pkgs.fetchFromGitHub {
            owner = "DrKJeff16";
            repo = "project.nvim";
            rev = "a15becb01e829d9c6de3fc36eec05c19acea7f4f";
            sha256 = "19lz17g25z9f7c1fm8774jlcqqf0hxf4h33qx8ydccwm5sjm88rx";
          };
        })
        (vimUtils.buildVimPlugin {
          name = "nvim-quicktype";
          src = pkgs.fetchFromGitHub {
            owner = "Lippiece";
            repo = "nvim-quicktype";
            rev = "7ef6d2bc43cf945f5d418e2e58d61297c05f39b8";
            sha256 = "0j4a932p17c9fqpvk3svj6jqp26jvms8kp83hfahfvpmr29sspxx";
          };
        })
        (vimUtils.buildVimPlugin {
          name = "tsc";
          nvimRequireCheck = "tsc";
          src = pkgs.fetchFromGitHub {
            owner = "dmmulroy";
            repo = "tsc.nvim";
            rev = "8c1b4ec6a48d038a79ced8674cb15e7db6dd8ef0";
            sha256 = "00irwjlm3r741i06w6qd6pmgqcs5zh1faz2fnqvlzgm7pyb4qz50";
          };
        })
      ];
      extraConfigLua =
        #lua
        ''
          vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
          vim.opt.shortmess:append { W = true, I = true, c = true, C = true }

          if vim.g.neovide then
            vim.opt.scrolloff = 15
            vim.g.neovide_opacity = 0.9

            -- vim.g.neovide_font_hinting = "none"
            -- vim.g.neovide_font_edging = "subpixelantialias"

            -- vim.keymap.set("n", "<C-v>", '"+P') -- Paste normal mode
            -- vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
            vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
            vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode
          end

          -- Highlight on yank
          local highlight_group =
            vim.api.nvim_create_augroup("YankHighlight", { clear = true })
          vim.api.nvim_create_autocmd("TextYankPost", {
            callback = function()
              vim.highlight.on_yank()
            end,
            group = highlight_group,
            pattern = "*",
          })

          -- NOTE: custom plugins
          require"unception"
          require"automkdir".setup()
          require"ts-error-translator".setup()
          require"nvim_context_vt".setup()
          -- TODO: https://github.com/nix-community/nixvim/issues/3654
          require"project".setup()
          require("nvim-quicktype").setup({
            global = {
              -- Quicktype global options
              quicktype_cmd = ${"\"" + pkgs.quicktype + "/bin/quicktype\""}, -- Path to the quicktype executable
              src_lang = "json", -- The language of the input
              no_combine_classes = false, -- Do not combine classes with shared properties into a single base class
              all_properties_optional = false, -- Make all properties optional
              alphabetize_properties = false, -- Alphabetize properties
              telemetry = "disable", -- Send telemetry data to Quicktype (can be "enable", or "disable")
              -- output_file = nil, -- Output file (if not specified, output is printed to stdout)
              debug_dir = "/tmp/", -- Directory to write debug info to (if not specified, no debug info is written)
            },
            filetypes = {
              -- Quicktype language-specific options
              typescript = {
                lang = "typescript", -- The language to generate types for
                additional_options = {
                  -- Add any additional options here
                  -- Example:
                  ["just-types"] = true,
                  -- ["prefer-unions"] = true,
                },
              },
              -- Add more filetypes as needed
            },
          })
          require"tsc".setup({
            use_trouble_qflist = true,
          })

          vim.opt.rtp:prepend(${"\"" + pkgs.vimPlugins.vim-fetch + "\""})

          -- NOTE: LSP
          vim.lsp.config("jsonls", {
            -- Schemastore won't work otherwise
            -- https://github.com/Saghen/blink.cmp/issues/2096
            before_init = function(_, config)
              config.settings.json.schemas = config.settings.json.schemas or {}
              vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
              json = {
                validate = { enable = true },
              },
            },
          })
          vim.lsp.config("vtsls", {
            filetypes = vim.tbl_deep_extend("force",
              vim.lsp.config.vtsls.filetypes, { "vue" }),
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      languages = { "vue" },
                      configNamespace = "typescript",
                      location =
                      "/home/lippiece/node_modules/@vue/language-server",
                    },
                  },
                },
              },
            },
          })
          vim.lsp.config("vue_ls", {
            on_init = function(client)
              client.handlers["tsserver/request"] = function(_, result, context)
                local clients =
                  vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
                if #clients == 0 then
                  vim.notify(
                    "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                    vim.log.levels.ERROR
                  )
                  return
                end
                local ts_client = clients[1]
                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = "vue_request_forward",
                  command = "typescript.tsserverRequest",
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response_data = { { id, r.body } }
                  ---@diagnostic disable-next-line: param-type-mismatch
                  client:notify("tsserver/response", response_data)
                end)
              end
            end,
          })
          vim.lsp.enable("vue_ls")
        '';

      lsp = {
        inlayHints.enable = true;
        keymaps = [
          {
            key = "gd";
            action = "<cmd>Trouble lsp_definitions<cr>";
            options.desc = "Go to Definition";
          }
          {
            key = "gr";
            action = "<cmd>Trouble lsp_references<cr>";
            options.desc = "Show References";
          }
          {
            key = "gt";
            action = "<cmd>Trouble lsp_type_definitions<cr>";
            options.desc = "Go to Type Definition";
          }
          {
            key = "gI";
            action = "<cmd>Trouble lsp_implementations<cr>";
            options.desc = "Go to Implementation";
          }
          {
            key = "gD";
            action = "<cmd>Trouble lsp_declarations<cr>";
            options.desc = "Go to Declaration";
          }
          {
            key = "cr";
            lspBufAction = "rename";
            options.desc = "Rename";
          }
        ];
        servers = {
          nixd = {
            enable = true;
            activate = true;
            settings = let
              flake = ''(builtins.getFlake (builtins.toString ./.))'';
              system = ''''${builtins.currentSystem}'';
            in {
              nixpkgs.expr = "import ${flake}.inputs.nixpkgs {}";

              options = {
                nixos.expr = ''${flake}.nixosConfigurations.mothership.options'';
                # BUG: doesn't work: https://github.com/nix-community/nixd/issues/706
                nixvim.expr = ''${flake}.inputs.nixvim.nixvimConfigurations.${system}.default.options'';
                home_manager.expr = ''${flake}.nixosConfigurations.mothership.options.home-manager.users.type.getSubOptions []'';
              };
            };
          };
          lua_ls = {
            enable = true;
            activate = true;
          };
          yamlls = {
            enable = true;
            activate = true;
          };
          jsonls = {
            enable = true;
            activate = true;
          };
          vtsls = {
            enable = true;
            activate = true;
          };
          astro = {
            enable = true;
            activate = true;
          };
          tailwindcss = {
            enable = true;
            activate = true;
          };
          emmet_language_server = {
            enable = true;
            activate = true;
          };
        };
      };

      keymaps = [
        {
          action.__raw =
            # lua
            ''
              function ()
                require("neo-tree.command").execute { toggle = true, reveal = true }
              end
            '';
          key = "<Leader>e";
          mode = ["n"];
          options = {
            desc = "Open neo-tree";
            silent = true;
            noremap = true;
          };
        }

        # Better up/down
        {
          key = "j";
          mode = ["n" "x"];
          action = "v:count == 0 ? 'gj' : 'j'";
          options = {
            silent = true;
            expr = true;
            desc = "Down";
          };
        }
        {
          key = "k";
          mode = ["n" "x"];
          action = "v:count == 0 ? 'gk' : 'k'";
          options = {
            silent = true;
            expr = true;
            desc = "Up";
          };
        }

        {
          key = "<C-h>";
          mode = ["n"];
          action = "<C-w>h";
          options = {
            remap = true;
            desc = "Go to Left Window";
          };
        }
        {
          key = "<C-j>";
          mode = ["n"];
          action = "<C-w>j";
          options = {
            remap = true;
            desc = "Go to Lower Window";
          };
        }
        {
          key = "<C-k>";
          mode = ["n"];
          action = "<C-w>k";
          options = {
            remap = true;
            desc = "Go to Upper Window";
          };
        }
        {
          key = "<C-l>";
          mode = ["n"];
          action = "<C-w>l";
          options = {
            remap = true;
            desc = "Go to Right Window";
          };
        }

        {
          key = "<C-Up>";
          mode = ["n"];
          action = "<cmd>resize +2<cr>";
          options = {
            desc = "Increase Window Height";
          };
        }
        {
          key = "<C-Down>";
          mode = ["n"];
          action = "<cmd>resize -2<cr>";
          options = {
            desc = "Decrease Window Height";
          };
        }
        {
          key = "<C-Left>";
          mode = ["n"];
          action = "<cmd>vertical resize -2<cr>";
          options = {
            desc = "Decrease Window Width";
          };
        }
        {
          key = "<C-Right>";
          mode = ["n"];
          action = "<cmd>vertical resize +2<cr>";
          options = {
            desc = "Increase Window Width";
          };
        }

        {
          key = "<S-h>";
          mode = ["n"];
          action = "<cmd>bprevious<cr>";
          options = {
            desc = "Prev Buffer";
          };
        }
        {
          key = "<S-l>";
          mode = ["n"];
          action = "<cmd>bnext<cr>";
          options = {
            desc = "Next Buffer";
          };
        }
        {
          key = "<leader>bb";
          mode = ["n"];
          action = "<cmd>e #<cr>";
          options = {
            desc = "Switch to Other Buffer";
          };
        }
        {
          key = "<leader>`";
          mode = ["n"];
          action = "<cmd>e #<cr>";
          options = {
            desc = "Switch to Other Buffer";
          };
        }

        {
          key = "<leader>bd";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.bufdelete()
            end
          '';
          options = {
            desc = "Delete Buffer";
          };
        }
        {
          key = "<leader>bo";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.bufdelete.other()
            end
          '';
          options = {
            desc = "Delete Other Buffers";
          };
        }
        {
          key = "<leader>bD";
          mode = ["n"];
          action = "<cmd>:bd<cr>";
          options = {
            desc = "Delete Buffer and Window";
          };
        }

        {
          key = "<leader>ur";
          mode = ["n"];
          action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
          options = {
            desc = "Redraw / Clear hlsearch / Diff Update";
          };
        }

        {
          key = "n";
          mode = ["n"];
          action = "'Nn'[v:searchforward].'zv'";
          options = {
            expr = true;
            desc = "Next Search Result";
          };
        }
        {
          key = "n";
          mode = ["x"];
          action = "'Nn'[v:searchforward]";
          options = {
            expr = true;
            desc = "Next Search Result";
          };
        }
        {
          key = "n";
          mode = ["o"];
          action = "'Nn'[v:searchforward]";
          options = {
            expr = true;
            desc = "Next Search Result";
          };
        }
        {
          key = "N";
          mode = ["n"];
          action = "'nN'[v:searchforward].'zv'";
          options = {
            expr = true;
            desc = "Prev Search Result";
          };
        }
        {
          key = "N";
          mode = ["x"];
          action = "'nN'[v:searchforward]";
          options = {
            expr = true;
            desc = "Prev Search Result";
          };
        }
        {
          key = "N";
          mode = ["o"];
          action = "'nN'[v:searchforward]";
          options = {
            expr = true;
            desc = "Prev Search Result";
          };
        }

        # Add undo break-points
        {
          key = ",";
          mode = ["i"];
          action = ",<c-g>u";
        }
        {
          key = ".";
          mode = ["i"];
          action = ".<c-g>u";
        }
        {
          key = ";";
          mode = ["i"];
          action = ";<c-g>u";
        }

        {
          key = "<leader>K";
          mode = ["n"];
          action = "<cmd>norm! K<cr>";
          options = {
            desc = "Keywordprg";
          };
        }

        # Better indenting
        {
          key = "<";
          mode = ["v"];
          action = "<gv";
        }
        {
          key = ">";
          mode = ["v"];
          action = ">gv";
        }

        # Insert comment below/above
        {
          key = "gco";
          mode = ["n"];
          action = "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
          options = {
            desc = "Add Comment Below";
          };
        }
        {
          key = "gcO";
          mode = ["n"];
          action = "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>";
          options = {
            desc = "Add Comment Above";
          };
        }

        {
          key = "<leader>fn";
          mode = ["n"];
          action = "<cmd>enew<cr>";
          options = {
            desc = "New File";
          };
        }

        {
          key = "[q";
          mode = ["n"];
          action = "vim.cmd.cprev";
          options = {
            desc = "Previous Quickfix";
          };
        }
        {
          key = "]q";
          mode = ["n"];
          action = "vim.cmd.cnext";
          options = {
            desc = "Next Quickfix";
          };
        }

        {
          key = "<leader>cd";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.open_float()
            end
          '';
          options = {
            desc = "Line Diagnostics";
          };
        }
        {
          key = "]d";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.jump({
                count = 1,
                float = true,
              })
            end
          '';
          options = {
            desc = "Next Diagnostic";
          };
        }
        {
          key = "[d";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.jump({
                count = -1,
                float = true,
              })
            end
          '';
          options = {
            desc = "Prev Diagnostic";
          };
        }
        {
          key = "]e";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.jump({
                severity = "ERROR",
                count = 1,
                float = true,
              })
            end
          '';
          options = {
            desc = "Next Error";
          };
        }
        {
          key = "[e";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.jump({
                severity = "ERROR",
                count = -1,
                float = true,
              })
            end
          '';
          options = {
            desc = "Prev Error";
          };
        }
        {
          key = "]w";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.jump({
                severity = "WARN",
                count = 1,
                float = true,
              })
            end
          '';
          options = {
            desc = "Next Warning";
          };
        }
        {
          key = "[w";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.diagnostic.jump({
                severity = "WARN",
                count = -1,
                float = true,
              })
            end
          '';
          options = {
            desc = "Prev Warning";
          };
        }

        {
          key = "<leader>gg";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.lazygit()
            end
          '';
          options = {
            desc = "Lazygit (cwd)";
          };
        }

        {
          key = "<leader>gb";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.picker.git_log_line()
            end
          '';
          options = {
            desc = "Git Blame Line";
          };
        }
        {
          key = "<leader>gB";
          mode = ["n" "x"];
          action.__raw = ''
            function()
              Snacks.gitbrowse()
            end
          '';
          options = {
            desc = "Git Browse (open)";
          };
        }
        {
          key = "<leader>gY";
          mode = ["n" "x"];
          action.__raw = ''
            function()
              Snacks.gitbrowse {
                open = function(url)
                  vim.fn.setreg("+", url)
                end,
                notify = false,
              }
            end
          '';
          options = {
            desc = "Git Browse (copy)";
          };
        }

        {
          key = "<C-/>";
          mode = ["t"];
          action = "<cmd>close<cr>";
          options = {
            desc = "Hide Terminal";
          };
        }

        {
          key = "<c-_>";
          mode = ["t"];
          action = "<cmd>close<cr>";
          options = {
            desc = "which_key_ignore";
          };
        }

        {
          key = "<leader>-";
          mode = ["n"];
          action = "<C-W>s";
          options = {
            remap = true;
            desc = "Split Window Below";
          };
        }
        {
          key = "<leader>|";
          mode = ["n"];
          action = "<C-W>v";
          options = {
            remap = true;
            desc = "Split Window Right";
          };
        }
        {
          key = "<leader>wd";
          mode = ["n"];
          action = "<C-W>c";
          options = {
            remap = true;
            desc = "Delete Window";
          };
        }

        {
          key = "<leader><tab>l";
          mode = ["n"];
          action = "<cmd>tablast<cr>";
          options = {
            desc = "Last Tab";
          };
        }
        {
          key = "<leader><tab>o";
          mode = ["n"];
          action = "<cmd>tabonly<cr>";
          options = {
            desc = "Close Other Tabs";
          };
        }
        {
          key = "<leader><tab>f";
          mode = ["n"];
          action = "<cmd>tabfirst<cr>";
          options = {
            desc = "First Tab";
          };
        }
        {
          key = "<leader><tab><tab>";
          mode = ["n"];
          action = "<cmd>tabnew<cr>";
          options = {
            desc = "New Tab";
          };
        }
        {
          key = "<leader><tab>]";
          mode = ["n"];
          action = "<cmd>tabnext<cr>";
          options = {
            desc = "Next Tab";
          };
        }
        {
          key = "<leader><tab>d";
          mode = ["n"];
          action = "<cmd>tabclose<cr>";
          options = {
            desc = "Close Tab";
          };
        }
        {
          key = "<leader><tab>[";
          mode = ["n"];
          action = "<cmd>tabprevious<cr>";
          options = {
            desc = "Previous Tab";
          };
        }

        {
          key = "<leader>cl";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.picker.lsp_config()
            end
          '';
          options = {
            desc = "Lsp Info";
          };
        }

        {
          key = "<leader>/";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.picker.grep()
            end
          '';
          options = {
            desc = "Find text";
          };
        }
        {
          key = "<leader><space>";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.picker.files()
            end
          '';
          options = {
            desc = "Find files";
          };
        }

        {
          key = "<leader>cc";
          mode = ["n" "v"];
          action.__raw = ''
            function()
              vim.lsp.codelens.run()
            end
          '';
          options = {
            desc = "Run Codelens";
          };
        }

        {
          key = "<leader>cC";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.lsp.codelens.refresh()
            end
          '';
          options = {
            desc = "Refresh & Display Codelens";
          };
        }

        {
          key = "<leader>cR";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.rename.rename_file()
            end
          '';
          options = {
            desc = "Rename File";
          };
        }

        # LSP code action variants
        {
          key = "<Leader>cM";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.lsp.buf.code_action {
                apply = true,
                context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
              }
            end
          '';
          options = {
            desc = "Add missing imports";
          };
        }
        {
          key = "<Leader>cu";
          mode = ["n"];
          action.__raw = ''
            function()
              vim.lsp.buf.code_action {
                apply = true,
                context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
              }
            end
          '';
          options = {
            desc = "Remove unused code";
          };
        }
        {
          key = "<Leader>cA";
          mode = ["n"];
          action.__raw = ''
            function ()
              vim.lsp.buf.code_action {
                apply = true,
                context = { only = { "source" }, diagnostics = {} },
              }
            end
          '';
          options.desc = "Code Action (file)";
        }
        {
          key = "<Leader>ca";
          mode = ["n" "v"];
          action.__raw = ''
            function ()
              require"fastaction".code_action {}
            end
          '';
          options.desc = "Code Action (fastaction)";
        }

        {
          key = "<Leader>cf";
          mode = ["n"];
          action.__raw = ''
            function()
              require("conform").format()
            end
          '';
          options = {
            desc = "Format file";
          };
        }

        {
          key = "]]";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.words.jump(1)
            end
          '';
          options = {
            desc = "Next Reference";
          };
        }

        {
          key = "[[";
          mode = ["n"];
          action.__raw = ''
            function()
              Snacks.words.jump(-1)
            end
          '';
          options = {
            desc = "Prev Reference";
          };
        }

        {
          key = "<Esc>";
          mode = ["n"];
          action = "<cmd>noh<CR>";
          options = {
            desc = "general clear highlights";
          };
        }

        {
          key = "<leader>uf";
          mode = ["n"];
          action.__raw = ''
            function()
              if vim.b.disable_autoformat then
                vim.b.disable_autoformat = false
                vim.print "Enabled autoformat-on-save"
              else
                vim.b.disable_autoformat = true
                vim.print "Disabled autoformat-on-save"
              end
            end
          '';
          options.desc = "Toggle autoformat-on-save in buffer";
        }
        {
          key = "<leader>uF";
          mode = ["n"];
          action.__raw = ''
            function()
              if vim.g.disable_autoformat then
                vim.g.disable_autoformat = false
                vim.print "Enabled autoformat-on-save"
              else
                vim.g.disable_autoformat = true
                vim.print "Disabled autoformat-on-save"
              end
            end
          '';
          options.desc = "Toggle autoformat-on-save globally";
        }

        {
          key = "<leader>xx";
          mode = ["n"];
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          options.desc = "Buffer Diagnostics (Trouble)";
        }
        {
          key = "<leader>xX";
          mode = ["n"];
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options.desc = "Diagnostics (Trouble)";
        }

        {
          key = "<leader>n";
          mode = ["n"];
          action = "<cmd>NoiceSnacks<cr>";
          options.desc = "Show notifications (snacks + noice)";
        }

        {
          key = "<leader>n";
          mode = ["n"];
          action = "<cmd>NoiceSnacks<cr>";
          options.desc = "Show notifications (snacks + noice)";
        }

        # Refactoring
        {
          key = "<leader>rp";
          mode = ["x" "n"];
          action.__raw = ''
            function()
              require('refactoring').select_refactor({
                prefer_ex_cmd = true,
              })
            end
          '';
          options.desc = "Select a refactor to apply";
        }

        # dmmulroy/tsc.nvim
        {
          key = "<leader>tt";
          mode = ["x" "n"];
          action.__raw = ''
            function()
              require("tsc").run()
            end
          '';
          options.desc = "Run tsc";
        }
        {
          key = "<leader>tv";
          mode = ["x" "n"];
          action.__raw = ''
            function()
              require("tsc").setup {
                use_trouble_qflist = true,
                bin_path = "node_modules/.bin/vue-tsc",
              }
              require("tsc").run()
            end
          '';
          options.desc = "Run vue-tsc";
        }

        # Redoxahmii/json-to-types.nvim
        {
          key = "<leader>ct";
          action = "<CMD>ConvertJSONtoLangBuffer typescript<CR>";
          options.desc = "Convert JSON to TS from buffer";
        }
      ];

      diagnostic.settings = {
        severity_sort = true;
        virtual_text = true;
      };

      nixpkgs = {
        config = {
          allowUnfree = true;
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
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      harpoon
      kanagawa
    ];
    newSession = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    extraConfig =
      # tmux
      ''
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
          Type = "oneshot";
          ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/krunner -d";
        };

        Install = {
          WantedBy = ["graphical-session.target"];
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
      "codeium"
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
