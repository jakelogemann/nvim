return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    enabled = true,
    cmd = { "Neotree" },
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree focus toggle<cr>", "Neotree" },
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
        --tab_labels = { -- table
        --  filesystem = "  Files ", -- string | nil
        --  buffers = "  Buffers ", -- string | nil
        --  git_status = "  Git ", -- string | nil
        --  diagnostics = " 裂Diagnostics ", -- string | nil
        --},
        content_layout = "start", -- string
        tabs_layout = "equal", -- string
        truncation_character = "…", -- string
        tabs_min_width = nil, -- int | nil
        tabs_max_width = nil, -- int | nil
        padding = 0, -- int | { left: int, right: int }
        separator = { left = "▏", right = "▕" },
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
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
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
    lazy = true,
    enabled = true,
    event = "UiEnter",
    keys = {
      { "<f1>", "<cmd>Telescope help_tags<cr>", desc = "Search help topics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "help tags" },
      { "<leader>s/", "<cmd>Telescope builtin<cr>", desc = "available" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "diagnostics" },
      { "<leader>st", "<cmd>Telescope treesitter<cr>", desc = "treesitter" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "find files" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "quickfix" },
      { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "loclist" },
      { "<leader>s`", "<cmd>Telescope marks<cr>", desc = "marks" },
      { "<leader>sb", "<cmd>Telescope buffer<cr>", desc = "buffers" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "commands" },
    },

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

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
}
