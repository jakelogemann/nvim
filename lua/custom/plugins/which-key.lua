return {
  {
    "folke/which-key.nvim",
    lazy = false,
    enabled = true,
    cmd = { "WhichKey" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").register {
        ["<C-s>"] = { "<cmd>write<cr>", "write buffer" },
        ["<leader>"] = {
          a = { name = "Actions" },
          b = {
            name = "buffer",
            ["/"] = { "<cmd>Telescope buffers<cr>", "find buffer" },
            n = { "<cmd>bNext<cr>", "next buffer" },
            p = { "<cmd>bprev<cr>", "prev buffer" },
            w = { "<cmd>write<cr>", "write buffer" },
            d = { "<cmd>bdelete<cr>", "delete buffer" },
            N = { "<cmd>bnew<cr>", "new buffer" },
            e = { "<cmd>enew<cr>", "new scratch" },
          },
          f = {
            name = "file",
            ["/"] = { "<cmd>Telescope live_grep<cr>", "live grep" },
          },
          g = {
            name = "git",
            g = { "<cmd>Neogit kind=tab<cr>", "git ui" },
            s = { "<cmd>Telescope git_status<cr>", "git status" },
            ["]"] = { "<cmd>Gitsigns next_hunk<cr>", "next hunk" },
            ["["] = { "<cmd>Gitsigns prev_hunk<cr>", "prev hunk" },
          },
          h = {
            name = "help",
            ["/"] = { "<cmd>Telescope help_tags<cr>", "help tags" },
            M = { "<cmd>Telescope man_pages<cr>", "man pages" },
            N = { "<cmd>help nvim.txt<cr>", "NVIM Reference" },
            P = { "<cmd>help lazy.nvim.txt<cr>", "Plugin Manager" },
            l = { "<cmd>help lua.vim<cr>", "Lua Guide" },
            L = { "<cmd>help luaref-Lib<cr>", "Lua Reference" },
          },
          i = {
            name = "insert",
            d = { function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date()), "n", true) end, "date" },
            t = { function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%R"), "n", true) end, "time" },
            y = { function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%Y"), "n", true) end, "year" },
          },
          p = {
            name = "project",
            ["/"] = { "<cmd>Telescope find_files<cr>", "find file" },
            c = { "<cmd>Neoconf<cr>", "project config" },
          },
          s = { name = "search" },
          t = {
            name = "tab",
            n = { "<cmd>tabNext<cr>", "next tab" },
            p = { "<cmd>tabprev<cr>", "prev tab" },
            N = { "<cmd>tabnew<cr>", "new tab" },
          },
          u = {
            name = "ui",
            w = {
              function()
                vim.ui.input(
                  { prompt = "set shiftwidth " },
                  function(input) vim.o.shiftwidth = tonumber(input) or vim.o.shiftwidth end
                )
              end,
              "shiftwidth",
            },
          },
          U = { name = "User" },
          w = { name = "Window" },
          z = {
            name = "toggle",
            ["gs"] = { "<cmd>Gitsigns toggle_signs<cr>", "git signs" },
            o = { "<cmd>SymbolsOutline<cr>", "symbols" },
            c = { function() vim.opt.conceallevel = vim.opt.conceallevel == 0 and 2 or 0 end, "conceal" },
            l = { function() vim.bo.list = not vim.opt.list end, "list" },
            p = { function() vim.bo.paste = not vim.opt.paste:get() end, "paste" },
            s = { function() vim.bo.spell = not vim.opt.spell end, "spell" },
            r = { function() vim.wo.ruler = not vim.opt.ruler:get() end, "ruler" },
            w = { function() vim.wo.wrap = not vim.opt.wrap end, "wrap" },
            ["<tab>"] = {
              function()
                vim.ui.select({ "tabs", "spaces" }, {
                  prompt = "Select tabs or spaces:",
                  format_item = function(item) return "I'd like to use " .. item end,
                }, function(choice)
                  if choice == "spaces" then
                    vim.bo.expandtab = true
                  else
                    vim.bo.expandtab = false
                  end
                end)
              end,
              "tabs/spaces",
            },
          },
        },
      }
    end,
    -- options for which-key.nvim
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
        position = "bottom", -- bottom, top
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
}
-- vim: fdl=1 fen fdm=expr
