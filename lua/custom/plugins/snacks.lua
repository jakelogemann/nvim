return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader><space>", function() require("custom.pick").smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() require("custom.pick").buffers() end, desc = "Buffers" },
    { "<leader>/", function() require("custom.pick").grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- keep notifications on <leader>n only

    -- find
    -- buffers available via <leader>,; avoid duplicate under <leader>f
    { "<leader>fc", function() require("custom.pick").files { cwd = vim.fn.stdpath "config" } end, desc = "Find Config File" },
    { "<leader>ff", function() require("custom.pick").files() end, desc = "Find Files" },
    { "<leader>fg", function()
      local pick = require "custom.pick"
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.picker and snacks.picker.git_files then
        return snacks.picker.git_files { cwd = pick.root() }
      end
      return pick.files { cwd = pick.root() }
    end, desc = "Find Git Files" },
    { "<leader>fp", function() require("custom.pick").projects() end, desc = "Projects" },
    { "<leader>fr", function() require("custom.pick").recent() end, desc = "Recent" },

    -- search
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    -- command history available via <leader>:
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },

    -- LSP keymaps are buffer-local in mason on_attach; avoid global duplicates here

    { "<leader>Tn", function() Snacks.terminal() end, desc = "New Terminal" },
  },
  opts = {
    dim = {},
    image = {},
    indent = {},
    lazygit = {},
    notifier = {},
    picker = {
      hidden = true,
      ignored = true,
      -- Layout preset for consistent UX across pickers
      layout = {
        preset = "vertical", -- common, compact layout (fallback-friendly)
        width = 0.9,
        height = 0.85,
      },
      border = "rounded",
    },
    scope = {},
    scratch = {},
    scroll = {},
    terminal = {},
    toggle = {},
  },
}
