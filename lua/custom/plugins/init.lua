return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme "catppuccin-macchiato" end,
  },
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts) require("copilot").setup(opts) end,
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
    "echasnovski/mini.nvim",
    lazy = false,
    init = function() require("mini.surround").setup {} end,
  },
  -- generic plugins with no configuration are enumerated below.
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
  },
  {
    "tjdevries/colorbuddy.nvim",
    event = "UiEnter",
  },
  {
    "aarondiel/spread.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    keys = {
      { "<leader>ac", '<cmd>lua require("spread").combine()<cr>', desc = "combine arguments" },
      { "<leader>as", '<cmd>lua require("spread").out()<cr>', desc = "spread arguments" },
    },
  },
  {
    "folke/styler.nvim", -- Sets custom colorschemes by filetype.
    cmd = { "Styler" },
    opts = {
      themes = {
        help = { colorscheme = "gruvbuddy", background = "dark" },
      },
    },
  },
  {
    "folke/neoconf.nvim",
    cmd = { "Neoconf" },
    lazy = true,
  },
  {
    "b0o/SchemaStore.nvim",
    event = "VeryLazy",
    module = "schemastore",
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "nvzone/typr",
    cmd = { "Typr", "TyprStats" },
    dependencies = { "nvzone/volt" },
    opts = {},
  },
  {
    -- Useful status updates for LSP
    "j-hui/fidget.nvim",
  },
  { -- adds icons for current signature (as defined by the LSP)
    "onsails/lspkind.nvim",
    lazy = true,
    enable = not vim.g.icons,
    dependencies = { "neovim/nvim-lspconfig" },
  },
}
