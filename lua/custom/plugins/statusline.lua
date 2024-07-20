return {
  { -- simplistic lua statusline plugin.
    "nvim-lualine/lualine.nvim",
    lazy = false,
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
}
-- vim: fdl=1 fen fdm=expr
