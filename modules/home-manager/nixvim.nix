{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    dockerfile-language-server
  ];

  home.file = {
    ".config/nvim/snippets/friendly".source = "${pkgs.vimPlugins.friendly-snippets}/snippets";
    ".config/nvim/lsp/typenix".text =
      #lua
      ''
        return {
          cmd = function(dispatchers)
            local cmd = "typenix"
            return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
          end,
          root_markers = { "flake.nix", ".git" },
          filetypes = {
            "nix",
            "nixts",
          },
        }
      '';
    ".config/nvim/snippets/package.json".text =
      #json
      ''
        {
          "contributes": {
            "snippets": [
              {
                "language": "svelte",
                "path"    : "./friendly/svelte.json"
              },
              {
                "language": "nix",
                "path"    : "./friendly/nix.json"
              },
              {
                "language": "html",
                "path"    : "./friendly/html.json"
              },
              {
                "language": "yaml",
                "path"    : "./friendly/docker/docker-compose.json"
              },
              {
                "language": "dockerfile",
                "path"    : "./friendly/docker/docker_file.json"
              },
              {
                "language": [
                  "javascript",
                  "vue",
                  "astro",
                  "svelte",
                  "typescript"
                ],
                "path": "./friendly/javascript/javascript.json"
              },
              {
                "language": "vue",
                "path"    : "./friendly/frameworks/vue/html.json"
              },
              {
                "language": "vue",
                "path"    : "./friendly/frameworks/vue/script.json"
              },
              {
                "language": "vue",
                "path"    : "./friendly/frameworks/vue/nuxt-html.json"
              },
              {
                "language": "vue",
                "path"    : "./friendly/frameworks/vue/nuxt-script.json"
              },
              {
                "language": "vue",
                "path"    : "./friendly/frameworks/vue/style.json"
              },
              {
                "language": "vue",
                "path"    : "./friendly/frameworks/vue/vue.json"
              },
              {
                "language": "typescript",
                "path"    : "./friendly/javascript/typescript.json"
              }
            ]
          },
          "name": "personal-snippets"
        }
      '';
  };
  programs.nixvim = {
    package = pkgs.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    vimdiffAlias = true;

    performance = {
      # combinePlugins = {
      #   combinePlugins.standalonePlugins = [
      #     "nvim-treesitter-queries-lua"
      #     "nvim-treesitter-queries"
      #     "treesitter-queries-lua"
      #     "treesitter-queries"
      #     "snacks"
      #     "snacks.nvim"
      #     "snacks-nvim"
      #   ];
      #   enable = true;
      # };
      byteCompileLua = {
        enable = true;
        configs = true;
        luaLib = true;
        initLua = false;
        nvimRuntime = true;
        plugins = true;
      };
    };

    globals = {
      mapleader = ",";
      maplocalleader = "\\";
      columns = 80;
    };

    opts = {
      shell = "fish";
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
      textwidth = 0;
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
      guifont = "Maple Mono:h10";
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

    colorschemes.modus.enable = true;

    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          astro = {
            enable = true;
            autostart = true;
          };
          lua_ls = {
            enable = true;
            autostart = true;
          };
          yamlls = {
            enable = true;
            autostart = true;
          };
          # toml
          taplo = {
            enable = true;
            autostart = true;
          };
          jsonls = {
            enable = true;
            autostart = true;
          };
          vtsls = {
            enable = true;
            autostart = true;
          };
          tailwindcss = {
            enable = true;
            autostart = true;
          };
          emmet_language_server = {
            enable = true;
            autostart = true;
          };
          unocss = {
            package = null;
            enable = true;
            autostart = true;
            settings.settings.unocss = {
              remToPxPreview = true;
            };
            settings.options.unocss = {
              remToPxPreview = true;
            };
          };
          svelte = {
            enable = true;
            autostart = true;
          };
          vue_ls = {
            enable = true;
            autostart = true;
          };
          cssls = {
            enable = true;
            autostart = true;
          };
          rust_analyzer = {
            enable = true;
            autostart = true;
            installCargo = true;
            installRustc = true;
          };
          dockerls = {
            enable = true;
            activate = true;
            autostart = true;
          };
        };
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
            enabled = false;
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
            accept = {
              auto_brackets = {
                enabled = true;
              };
            };
            menu = {
              auto_show_delay_ms = 100;
            };
          };
          sources = {
            default = ["lsp" "snippets" "path" "codeium"];
            providers = {
              codeium = {
                name = "Codeium";
                module = "codeium.blink";
                async = true;
                score_offset = -5;
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
        autoInstall = {
          enable = true;
          overrides = {
            oxlint = null;
          };
        };
        settings = {
          formatters = {
            oxlint_fix = {
              options = {
                ignore_errors = true;
              };
              format.__raw =
                #lua
                ''
                  function()
                    vim.g.disable_autoformat = true
                    vim.cmd([[LspOxlintFixAll]])
                    vim.cmd([[w]])
                    vim.g.disable_autoformat = false
                  end
                '';
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
          };
          formatters_by_ft = {
            # -- ["*"] = { "injected" };
            javascript = ["oxfmt"];
            typescript = ["oxfmt"];
            javascriptreact = ["oxfmt"];
            typescriptreact = ["oxfmt"];
            astro = ["prettier"];
            vue = ["oxfmt"];
            svelte = ["prettier"];
            css = ["oxfmt"];
            html = ["oxfmt"];
            json = ["oxfmt"];
            jsonc = ["oxfmt"];
            nix = ["alejandra"];
            lua = ["stylua"];
            # python = ["isort" "black"];
            yaml = ["yamlfmt"];
            # fish = ["fish_indent"];
            rust = ["rustfmt"];
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
                  ignore_errors = true,
                  lsp_format = "fallback",
                }
              end
            '';
          log_level = "info";
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

      windsurf-nvim = {
        enable = true;
        settings.enable_cmp_source = false;
      };

      lint = {
        enable = true;
        lintersByFt = {
          fish = ["fish"];
          json = ["jsonlint"];
          jsonc = ["jsonlint"];
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
      treesitter-textobjects = {
        enable = true;
        settings = {
          enable = true;
          move = {
            set_jumps = true;
          };
          selection_modes = {
            parameter.outer = "v";
            function.outer = "V";
            class.outer = "<c-v>";
          };
          keymaps = {
            ab = "@block.outer";
            ac = "@call.outer";
            ib = "@block.inner";
            ic = "@call.inner";
          };
          lookahead = true;
        };
      };
      treesj.enable = true;
      trouble.enable = true;
      ts-comments.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
      actions-preview.enable = true;
      dap.enable = true;
      sandwich.enable = true;
      git-conflict.enable = true;
      ccc.enable = true;
      snacks.enable = true;
      origami.enable = true;
      guess-indent.enable = true;
      bufferline.enable = true;
      telescope.enable = true;
      overseer.enable = true;
      friendly-snippets = {
        enable = true;
        package = pkgs.vimPlugins.friendly-snippets;
      };
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
          rev = "558abff11b9e8f4cefc0de09df780c56841c7a4b";
          sha256 = "17ilq1f4ig4zwh3nw2lz804ncd7z0bc4jhfhw61b21zlyrz70dlj";
        };
      })
      (vimUtils.buildVimPlugin {
        name = "nvim_context_vt";
        src = pkgs.fetchFromGitHub {
          owner = "andersevenrud";
          repo = "nvim_context_vt";
          rev = "fadbd9e57af72f6df3dd33df32ee733aa01cdbc0";
          sha256 = "0rx7lik3c40ka9y4qws0d960lzhvpnkv5hs512140dq4k2n5f6l2";
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
          rev = "e083bcf1e54bc3af7df92b33235efb334e8c782c";
          sha256 = "0f7as51kc3q3f8x0wv6v6xjdlw35blsnrkhyk2vkblprmryhk3sv";
        };
      })
      vimPlugins.treewalker-nvim
      (vimUtils.buildVimPlugin {
        name = "cheatsheet";
        nativeBuildInputs = [vimPlugins.telescope-nvim];
        src = pkgs.fetchFromGitHub {
          owner = "sudormrfbin";
          repo = "cheatsheet.nvim";
          rev = "9716f9aaa94dd1fd6ce59b5aae0e5f25e2a463ef";
          sha256 = "0dm94kppbnky8y0gs1pdfs7vcc9hyp8lf6h33dw6ndqfnw3hd2ad";
        };
      })
      (vimUtils.buildVimPlugin {
        name = "code-action-menu.nvim";
        nativeBuildInputs = [vimPlugins.snacks-nvim];
        src = pkgs.fetchFromGitHub {
          owner = "so1ve";
          repo = "code-action-menu.nvim";
          rev = "e18b1ad1c98350e13879d20eaaf3238d34890f04";
          sha256 = "0pg4d6qszphqgcxqv9z37bm0gkliqygmff55hcw693rmal2sakxy";
        };
      })
    ];
    extraConfigLua =
      #lua
      ''
        vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
        vim.opt.shortmess:append { W = true, I = true, c = true, C = true }

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
        require"treewalker".setup({
          -- Whether to briefly highlight the node after jumping to it
          highlight = true,
          -- How long should above highlight last (in ms)
          highlight_duration = 250,
          -- The color of the above highlight. Must be a valid vim highlight group.
          -- (see :h highlight-group for options)
          highlight_group = 'CursorLine',
          -- Whether to create a visual selection after a movement to a node.
          -- If true, highlight is disabled and a visual selection is made in
          -- its place.
          select = false,
          -- Whether to use vim.notify to warn when there are missing parsers or incorrect options
          notifications = true,
          -- Whether the plugin adds movements to the jumplist -- true | false | 'left'
          --  true: All movements more than 1 line are added to the jumplist. This is the default,
          --        and is meant to cover most use cases. It's modeled on how { and } natively add
          --        to the jumplist.
          --  false: Treewalker does not add to the jumplist at all
          --  "left": Treewalker only adds :Treewalker Left to the jumplist. This seems the most
          --          likely jump to cause location confusion, so use this to minimize writes
          --          to the jumplist, while maintaining some ability to go back.
          jumplist = true,
          -- Whether movement, when inside the scope of some node, should be confined to that scope.
          -- When true, when moving through neighboring nodes inside some node, you won't be able to
          -- move outside of that scope via :Treewalker Up/Down. When false, if on a node at the end
          -- of a scope, movement will bring you to the next node of similar indentation/number of
          -- ancestor nodes, even when it is outside of the scope you're currently in.
          scope_confined = false,
        })
        require("cheatsheet").setup({
            -- Whether to show bundled cheatsheets
            -- For generic cheatsheets like default, unicode, nerd-fonts, etc
            -- bundled_cheatsheets = {
            --     enabled = {},
            --     disabled = {},
            -- },
            bundled_cheatsheets = true,
            -- For plugin specific cheatsheets
            -- bundled_plugin_cheatsheets = {
            --     enabled = {},
            --     disabled = {},
            -- }
            bundled_plugin_cheatsheets = true,
            -- For bundled plugin cheatsheets, do not show a sheet if you
            -- don't have the plugin installed (searches runtimepath for
            -- same directory name)
            include_only_installed_plugins = true,
            -- Key mappings bound inside the telescope window
            telescope_mappings = {
                ['<CR>'] = require('cheatsheet.telescope.actions').select_or_fill_commandline,
                ['<A-CR>'] = require('cheatsheet.telescope.actions').select_or_execute,
                ['<C-Y>'] = require('cheatsheet.telescope.actions').copy_cheat_value,
                ['<C-E>'] = require('cheatsheet.telescope.actions').edit_user_cheatsheet,
            }
        })

        vim.opt.rtp:prepend(${"\"" + pkgs.vimPlugins.vim-fetch + "\""})

        require("code-action-menu").setup()

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
            vim.lsp.config.vtsls.filetypes, { "vue", "javascript" }),
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
        ---@type vim.lsp.Config
        vim.lsp.enable("typenix")
        vim.filetype.add({
          pattern = {
            [".*/*.nix.d.ts"] = "nixts",
          },
        })
        vim.treesitter.language.register("typescript", { "nixts" })

        -- use fish for nvim
        vim.api.nvim_create_autocmd({'VimEnter'}, {
          command = "let $SHELL = 'fish'",
        })
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
              # TODO: doesn't work: https://github.com/nix-community/nixd/issues/706
              nixvim.expr = ''${flake}.inputs.nixvim.nixvimConfigurations.${system}.default.options'';
              home_manager.expr = ''${flake}.nixosConfigurations.mothership.options.home-manager.users.type.getSubOptions []'';
            };
          };
        };
        oxlint = {
          enable = true;
          activate = true;
          # autostart = true;
          config = {
            cmd = [
              (lib.getExe pkgs.cpulimit)
              "-i"
              "-l"
              "30"
              "/home/lippiece/.bun/bin/oxlint"
              "--import-plugin"
              "--type-aware"
              "--lsp"
            ];
            root_markers = [
              "package.json"
            ];
          };
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

      # Diagnostics
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

      # Git
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
        key = "<leader>gY";
        mode = ["n" "x"];
        action = "<cmd>Telescope git_bcommits<cr>";
        options = {
          desc = "Git file history";
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

      # Windows
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

      # Tabs
      {
        key = "<leader><tab>l";
        mode = ["n"];
        action = "<cmd>tablast<cr>";
        options = {
          desc = "Last Tab";
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
        key = "<leader><tab>o";
        mode = ["n"];
        action = "<cmd>tabonly<cr>";
        options = {
          desc = "Close Other Tabs";
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

      # Snacks
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
            require"code-action-menu".code_action {}
          end
        '';
        options.desc = "Code Action (code-action-menu)";
      }
      {
        key = "<Esc>";
        mode = ["n"];
        action = "<cmd>noh<CR>";
        options = {
          desc = "general clear highlights";
        };
      }

      # Format
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

      # Trouble
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
        key = "<leader>xt";
        mode = ["n"];
        action = "<cmd>Trouble todo toggle<cr>";
        options.desc = "Trouble: Todos";
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
              flags = "-b"
            }
            require("tsc").run()
          end
        '';
        options.desc = "Run vue-tsc";
      }

      # Overseer
      {
        key = "<leader>uo";
        action = "<CMD>OverseerToggle<CR>";
        options.desc = "Toggle Overseer UI";
      }
      {
        key = "<leader>ur";
        action = "<CMD>OverseerRunCmd<CR>";
        options.desc = "Run command with Overseer";
      }
      {
        key = "<leader>ul";
        action = "<CMD>OverseerLoadBundle<CR>";
        options.desc = "Load Overseer command bundle";
      }

      # https://github.com/aaronik/treewalker.nvim
      # -- movement
      # vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
      {
        mode = ["n" "v"];
        key = "<C-k>";
        action = "<cmd>Treewalker Up<cr>";
      }
      # vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
      {
        mode = ["n" "v"];
        key = "<C-j>";
        action = "<cmd>Treewalker Down<cr>";
      }
      # vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
      {
        mode = ["n" "v"];
        key = "<C-h>";
        action = "<cmd>Treewalker Left<cr>";
      }
      # vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })
      {
        mode = ["n" "v"];
        key = "<C-l>";
        action = "<cmd>Treewalker Right<cr>";
      }
      #
      # -- swapping
      # vim.keymap.set('n', '<C-S-k>', '<cmd>Treewalker SwapUp<cr>', { silent = true })
      {
        key = "<C-S-k>";
        action = "<cmd>Treewalker SwapUp<cr>";
      }
      # vim.keymap.set('n', '<C-S-j>', '<cmd>Treewalker SwapDown<cr>', { silent = true })
      {
        key = "<C-S-j>";
        action = "<cmd>Treewalker SwapDown<cr>";
      }
      # vim.keymap.set('n', '<C-S-h>', '<cmd>Treewalker SwapLeft<cr>', { silent = true })
      {
        key = "<C-S-h>";
        action = "<cmd>Treewalker SwapLeft<cr>";
      }
      # vim.keymap.set('n', '<C-S-l>', '<cmd>Treewalker SwapRight<cr>', { silent = true })
      {
        key = "<C-S-l>";
        action = "<cmd>Treewalker SwapRight<cr>";
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
}
