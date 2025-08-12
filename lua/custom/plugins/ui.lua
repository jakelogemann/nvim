return {
  {
    "nvim-lualine/lualine.nvim",
    -- simplistic lua statusline plugin.
    lazy = false,
    enabled = true,
    module = "lualine",
    dependencies = {
      "catppuccin/nvim",
      "tjdevries/colorbuddy.nvim",
      "folke/lazy.nvim",
    },
    opts = {
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
        lualine_b = { "branch", "diff", "diagnostics" },
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
          {
            --- Show an Ollama status glyph (idle/working) if plugin loaded.
            -- @return string|nil icon text
            function()
              local status = require("ollama").status()
              if status == "IDLE" then
                return "󱙺" -- nf-md-robot-outline
              elseif status == "WORKING" then
                return "󰚩" -- nf-md-robot
              end
            end,
            cond = function()
              return package.loaded["ollama"] and require("ollama").status() ~= nil
            end,
          }
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
    },
  },

  {
    "folke/noice.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "Noice" },
    main = "noice",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      lsp = {
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        cmdline_output_to_split = false,
        inc_rename = true,
        lsp_doc_border = false,
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
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
    },
  },

  { -- fast, minimal fuzzy finder for.. everything.
    "nvim-telescope/telescope.nvim",
    lazy = true,
    enabled = true,
    dependencies = {"nvim-lua/plenary.nvim"},
    cmd = "Telescope",
    keys = {
      { "<f1>", "<cmd>Telescope help_tags<cr>", desc = "help tags" },
      { "<leader>b/", "<cmd>Telescope buffers<cr>", desc = "buffers search" },
      { "<leader>f/", "<cmd>Telescope live_grep<cr>", desc = "file search" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
      { "<leader>h/", "<cmd>Telescope help_tags<cr>", desc = "help search" },
      { "<M-Space><M-Space>", "<cmd>Telescope<cr>", desc = "telescope" },
      { "<M-f><M-f>", "<cmd>Telescope<cr>", desc = "find anything" },
      { "<M-f>/", "<cmd>Telescope builtin<cr>", desc = "find builtins" },
      { "<M-f>`", "<cmd>Telescope marks<cr>", desc = "find marks" },
      { "<M-f>b", "<cmd>Telescope buffer<cr>", desc = "find buffers" },
      { "<M-f>d", "<cmd>Telescope diagnostics<cr>", desc = "find diagnostics" },
      { "<M-f>f", "<cmd>Telescope find_files<cr>", desc = "find files" },
      { "<M-f>h", "<cmd>Telescope help_tags<cr>", desc = "find help_tags" },
      { "<M-f>l", "<cmd>Telescope loclist<cr>", desc = "find loclist" },
      { "<M-f>m", "<cmd>Telescope man_pages<cr>", desc = "find man pages" },
      { "<M-f>q", "<cmd>Telescope quickfix<cr>", desc = "find quickfix" },
      { "<M-f>t", "<cmd>Telescope treesitter<cr>", desc = "find treesitter" },
      { "<M-f>c", "<cmd>Telescope commands<cr>", desc = "find commands" },
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
}
-- vim: fdl=1 fen fdm=expr
