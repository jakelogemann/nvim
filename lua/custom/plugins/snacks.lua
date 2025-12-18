return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>.s", function() Snacks.scratch.select() end, desc = "Scratch: Select" },
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

    -- search (moved under <leader>f for consistency)
    { "<leader>fC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>fM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>fR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>fb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    -- command history available via <leader>:
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fi", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>fpS", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { '<leader>f"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>f/", function() Snacks.picker.search_history() end, desc = "Search History" },

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
