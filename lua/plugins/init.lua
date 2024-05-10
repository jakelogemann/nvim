return {
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
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme("catppuccin-macchiato") end,
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = {
      "ToggleTerm",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualSelection",
      "ToggleTermSetName",
      "ToggleTermToggleAll",
    },
    keys = {
      { "<leader>`", "<cmd>ToggleTerm direction=float<cr>", "Toggle Terminal" },
      { "<leader>zt", "<cmd>ToggleTerm direction=float<cr>", "Toggle Terminal" },
    },
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
    "fatih/vim-go",
    lazy = true,
    ft = { "go", "gomod", "gosum", "gowork", "godoc" },
    cmd = { "GoInstallBinaries" },
  },
  {"j-hui/fidget.nvim"},
  { -- Automatically installs LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    lazy = true,
    enabled = false,
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
    },
  },
  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
  },
  { -- "gc" to comment visual regions/lines
    "numToStr/Comment.nvim",
    opts = {
      ignore = "^$",
      mappings = false,
    },
  },
  { -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
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
    lazy = true,
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
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
    "folke/neoconf.nvim",
    cmd = "Neoconf",
  },
  {
    "lewis6991/impatient.nvim",
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
    "folke/neodev.nvim",
    opts = {},
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
}
-- vim: fdl=1 fen fdm=expr
