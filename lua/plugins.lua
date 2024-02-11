return {
  { -- Emac's ORG-mode; reimplemented for Neovim
    "nvim-orgmode/orgmode",
    lazy = true,
    ft = { "org" },
    config = true,
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    lazy = true,
    cmd = {
      "Git",
      "Gedit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
    },
  },
  {
    "tpope/vim-eunuch",
    lazy = true,
    cmd = {
      "Remove", -- Delete a file on disk without E211: File no longer available.
      "Delete", -- Delete a file on disk and the buffer too.
      "Move", -- Rename a buffer and the file on disk simultaneously. See also :Rename, :Copy, and :Duplicate.
      "Chmod", -- Change the permissions of the current file.
      "Mkdir", -- Create a directory, defaulting to the parent of the current file.
      "Cfind", -- Run find and load the results into the quickfix list.
      "Clocate", -- Run locate and load the results into the quickfix list.
      "Lfind",
      "Llocate", -- Like above, but use the location list.
      "Wall", -- Write every open window. Handy for kicking off tools like guard.
      "SudoWrite", -- Write a privileged file with sudo.
      "SudoEdit", -- Edit a privileged file with sudo.
    },
  },
  { -- my current colorscheme of choice.
    "catppuccin/nvim",
    event = "UiEnter",
    config = function() vim.cmd.colorscheme "catppuccin-macchiato" end,
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    cmd = "ToggleTerm",
    config = true,
    opts = {
      size = 10,
      open_mapping = [[<C-Space>]],
      shading_factor = 2,
      autochdir = true,
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    init = function() _G.Terminal = require("toggleterm.terminal").Terminal end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function() require("copilot").setup {} end,
  },
  { -- install/configure treesitter (syntax highlighting but.. better)
    "nvim-treesitter/nvim-treesitter",
    priority = 100,
    lazy = false,
    init = function()
      local parsers_install_dir = vim.fn.stdpath "data" .. "/parsers"
      vim.opt.runtimepath:append(parsers_install_dir)
      require("nvim-treesitter.configs").setup {
        parser_install_dir = parsers_install_dir,
        -- A list of parser names, or "all"
        ensure_installed = {
          "arduino",
          "astro",
          "bash",
          "c",
          "comment",
          "cpp",
          "css",
          "dockerfile",
          "erlang",
          "fish",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gowork",
          "haskell",
          "hcl",
          "help",
          "hjson",
          "html",
          "jsonnet",
          "lua",
          "make",
          "markdown",
          "mermaid",
          "nix",
          "proto",
          "python",
          "rst",
          "ruby",
          "rust",
          "scss",
          "sql",
          "svelte",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },
  {
    "fatih/vim-go",
    event = "VeryLazy",
  },
  { -- Language Server Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "j-hui/fidget.nvim",
      "onsails/lspkind.nvim",
    },
  },
  { -- Useful status updates for LSP
    "j-hui/fidget.nvim",
    lazy = true,
    config = true,
  },
  { -- Automatically installs LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    --lazy = true,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      require("mason").setup()
      local mason_lspconfig = require "mason-lspconfig"
      mason_lspconfig.setup { ensure_installed = require("lsp").ensure_installed }
      mason_lspconfig.setup_handlers { require("lsp").setup_server }
    end,
  },
  {
    "TimUntersberger/neogit",
    enable = false,
    config = true,
    opts = {
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
      -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
      auto_refresh = true,
      disable_builtin_notifications = false,
      use_magit_keybindings = false,
      -- Change the default way of opening neogit
      kind = "tab",
      -- The time after which an output console is shown for slow running commands
      console_timeout = 2000,
      -- Automatically show console if a command takes more than console_timeout milliseconds
      auto_show_console = true,
      -- Change the default way of opening the commit popup
      commit_popup = {
        kind = "split",
      },
      -- Change the default way of opening popups
      popup = {
        kind = "split",
      },
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      -- Setting any section to `false` will make the section not render at all
      sections = {
        untracked = {
          folded = false,
        },
        unstaged = {
          folded = false,
        },
        staged = {
          folded = false,
        },
        stashes = {
          folded = true,
        },
        unpulled = {
          hidden = false,
          folded = true,
        },
        unmerged = {
          hidden = false,
          folded = false,
        },
        recent = {
          folded = true,
        },
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        status = {
          -- Adds a mapping with "B" as key that does the "BranchPopup" command
          -- ["B"] = "BranchPopup",
          -- Removes the default mapping of "s"
          -- ["s"] = "",
        },
      },
    },
  },
  { -- add modifications to buffers "gutter" (by line numbers).
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  { -- simplistic lua statusline plugin.
    "nvim-lualine/lualine.nvim",
    lazy = false,
    module = "lualine",
    dependencies = {
      "catppuccin/nvim",
      "tjdevries/colorbuddy.nvim",
      "folke/lazy.nvim",
    },
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
          extensions = {
            "fugitive",
            "fzf",
            "man",
            "neo-tree",
            "quickfix",
            "symbols-outline",
            "toggleterm",
          },
          section_separators = {
            left = "",
            right = "",
          },
          component_separators = {
            left = "",
            right = "",
          },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
          },
          lualine_c = { "filename" },
          lualine_x = {
            "encoding",
            "fileformat",
            "filetype",
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "ff9e64" },
            },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
  },
  { -- "gc" to comment visual regions/lines
    "numToStr/Comment.nvim",
    config = true,
    opts = {
      ignore = "^$",
      mappings = false,
    },
  },
  { -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
  },
  { -- adds icons for current signature (as defined by the LSP)
    "onsails/lspkind.nvim",
    lazy = true,
    enable = not vim.g.icons,
    dependencies = { "neovim/nvim-lspconfig" },
  },
  { -- Parenthesis highlighting
    "p00f/nvim-ts-rainbow",
    enable = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { -- Autoclose tags
    "windwp/nvim-ts-autotag",
    enable = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { -- Context based commenting
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "hrsh7th/nvim-cmp",
    -- lazy-load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    config = true,
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      mappings = {
        ["<F5>"] = "refresh",
        ["o"] = "open",
      },

      source_selector = {
        winbar = false, -- toggle to show selector on winbar
        statusline = false, -- toggle to show selector on statusline
        show_scrolled_off_parent_node = false, -- boolean
        tab_labels = { -- table
          filesystem = "  Files ", -- string | nil
          buffers = "  Buffers ", -- string | nil
          git_status = "  Git ", -- string | nil
          diagnostics = " 裂Diagnostics ", -- string | nil
        },
        content_layout = "start", -- string
        tabs_layout = "equal", -- string
        truncation_character = "…", -- string
        tabs_min_width = nil, -- int | nil
        tabs_max_width = nil, -- int | nil
        padding = 0, -- int | { left: int, right: int }
        separator = { left = "▏", right = "▕" }, -- string | { left: string, right: string, override: string | nil }
        separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
        show_separator_on_edge = false, -- boolean
        highlight_tab = "NeoTreeTabInactive", -- string
        highlight_tab_active = "NeoTreeTabActive", -- string
        highlight_background = "NeoTreeTabInactive", -- string
        highlight_separator = "NeoTreeTabSeparatorInactive", -- string
        highlight_separator_active = "NeoTreeTabSeparatorActive", -- string
      },

      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },

      cwd_target = {
        sidebar = "tab", -- sidebar is when position = left or right
        current = "window", -- current is when position = current
      },

      filtered_items = {
        visible = true,
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          --"node_modules",
        },
        hide_by_pattern = {
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          ".gitignore",
          "vendor",
          "target",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          "thumbs.db",
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
    },
  },
  { -- fast, minimal fuzzy finder for.. everything.
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      local builtin = require "telescope.builtin"
      local user_command = function(n, d, f) vim.api.nvim_create_user_command(n, f, { desc = d }) end
      user_command("FindFiles", "Interactively find files", function() builtin.find_files {} end)
      user_command("GrepByWord", "Interactively grep by word", function() builtin.grep_string {} end)
      user_command("Symbols", "Interactively find symbols", function() builtin.symbols {} end)
      user_command("FindCommands", "Interactively find commands", function() builtin.commands {} end)
      user_command("ManPages", "Interactively find man pages", function() builtin.man_pages {} end)
      user_command("QF", "Interactively find quickfix", function() builtin.quickfix {} end)
      user_command("LOC", "Interactively find loclist", function() builtin.loclist {} end)
      user_command("FindHelp", "Interactively find help tags", function() builtin.help_tags {} end)
      user_command(
        "Buffers",
        "Find an open buffer",
        function()
          builtin.buffers {
            ignore_current_buffer = true,
            sort_lastused = true,
          }
        end
      )
    end,
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          bottom_pane = {
            height = 25,
            preview_cutoff = 120,
            prompt_position = "top",
          },
          center = {
            height = 0.4,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.5,
          },
          cursor = {
            height = 0.9,
            preview_cutoff = 40,
            width = 0.8,
          },
          horizontal = {
            height = 0.9,
            preview_cutoff = 120,
            prompt_position = "bottom",
            width = 0.8,
          },
          vertical = {
            height = 0.9,
            preview_cutoff = 40,
            prompt_position = "bottom",
            width = 0.8,
          },
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    config = true,
    opts = {
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      -- Buffer-local options to use for oil buffers
      buf_options = {},
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        number = false,
        relativenumber = false,
        conceallevel = 3,
        concealcursor = "n",
      },
      -- Restore window options to previous values when leaving an oil buffer
      restore_win_options = true,
      -- Skip the confirmation popup for simple operations
      skip_confirm_for_simple_edits = false,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
      -- Additionally, if it is a string that matches "action.<name>",
      -- it will use the mapping at require("oil.action").<name>
      -- Set to `false` to remove a keymap
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },
    },
  },
  {
    "cshuaimin/ssr.nvim",
    opts = {
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false,
      position = "right",
      relative_width = true,
      width = 25,
      auto_close = true,
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      preview_bg_highlight = "Pmenu",
      autofold_depth = nil,
      auto_unfold_hover = true,
      fold_markers = { "", "" },
      wrap = false,
      keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
        File = { icon = "", hl = "TSURI" },
        Module = { icon = "", hl = "TSNamespace" },
        Namespace = { icon = "", hl = "TSNamespace" },
        Package = { icon = "", hl = "TSNamespace" },
        Class = { icon = "𝓒", hl = "TSType" },
        Method = { icon = "ƒ", hl = "TSMethod" },
        Property = { icon = "", hl = "TSMethod" },
        Field = { icon = "", hl = "TSField" },
        Constructor = { icon = "", hl = "TSConstructor" },
        Enum = { icon = "ℰ", hl = "TSType" },
        Interface = { icon = "ﰮ", hl = "TSType" },
        Function = { icon = "", hl = "TSFunction" },
        Variable = { icon = "", hl = "TSConstant" },
        Constant = { icon = "", hl = "TSConstant" },
        String = { icon = "𝓐", hl = "TSString" },
        Number = { icon = "#", hl = "TSNumber" },
        Boolean = { icon = "⊨", hl = "TSBoolean" },
        Array = { icon = "", hl = "TSConstant" },
        Object = { icon = "⦿", hl = "TSType" },
        Key = { icon = "🔐", hl = "TSType" },
        Null = { icon = "NULL", hl = "TSType" },
        EnumMember = { icon = "", hl = "TSField" },
        Struct = { icon = "𝓢", hl = "TSType" },
        Event = { icon = "🗲", hl = "TSType" },
        Operator = { icon = "+", hl = "TSOperator" },
        TypeParameter = { icon = "𝙏", hl = "TSParameter" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "UiEnter",
    config = true,
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          -- select spelling suggestions when pressing z=
          enabled = true,
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      operators = { gc = "Comments" },
      key_labels = {
        ["<leader>"] = "SPC",
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "single", -- none, single, double, shadow
        position = "top", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
      hidden = {
        "<silent>",
        "<cmd>",
        "<Cmd>",
        "<CR>",
        "call",
        "lua",
        "^:",
        "^ ",
      }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
      },
      -- disable the WhichKey popup for certain buf types and file types.
      -- Disabled by deafult for Telescope
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    config = true,
    opts = {
      options = {
        show_buffer_close_icons = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
  },
  {
    "echasnovski/mini.nvim",
    lazy = false,
    init = function() require("mini.surround").setup {} end,
  },
  {
    "pwntester/octo.nvim",
    lazy = false,
    config = true,
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.nvim",
    },
    event = "UiEnter",
    config = function()
      require("noice").setup {
        routes = {
          -- {
          --   view = "notify",
          --   filter = { event = "msg_showmode" },
          -- },
        },
        cmdline = {
          format = {
            search_down = {
              view = "cmdline",
            },
            search_up = {
              view = "cmdline",
            },
          },
        },
      }
    end,
  },
  -- generic plugins with no configuration are enumerated below.
  { "sindrets/diffview.nvim", event = "VeryLazy" },
  { "tjdevries/colorbuddy.nvim", config = true, event = "UiEnter" },
  { "aarondiel/spread.nvim", event = "VeryLazy", dependencies = { "nvim-treesitter" } },
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  { "lewis6991/impatient.nvim", lazy = true },
  { "github/copilot.vim", cmd = "Copilot" },
  { "b0o/SchemaStore.nvim", event = "VeryLazy", module = "schemastore" },
  { "folke/persistence.nvim", event = "BufReadPre", module = "persistence", config = true },
  { "folke/neodev.nvim", config = true },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  { "L3MON4D3/LuaSnip", lazy = true },
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  { "saadparwaiz1/cmp_luasnip", lazy = true },
}
