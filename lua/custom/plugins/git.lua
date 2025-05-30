return {
  {
    "TimUntersberger/neogit",
    lazy = true,
    cmd = {
      "Neogit",
      "NeogitResetState",
    },
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
    lazy = true,
    enabled = true,
    event = "UiEnter",
    keys = {
      { "<leader>g[", "<cmd>Gitsigns prev_hunk<cr>", "prev hunk" },
      { "<leader>g]", "<cmd>Gitsigns next_hunk<cr>", "next hunk" },
      { "<leader>zgs", "<cmd>Gitsigns toggle_signs<cr>", "Toggle git signs" },
    },
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
}
-- vim: fdl=1 fen fdm=expr
