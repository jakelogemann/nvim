-- plugin manager configuration.
vim.g.mapleader = ' ' -- keep before most things so mappings are correct.
vim.g.plugin_root = vim.fn.stdpath 'data' .. '/lazy'
vim.g.plugin_manager = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
vim.g.plugin_manager_branch = 'stable'
vim.g.plugin_manager_repo = 'https://github.com/folke/lazy.nvim.git'

if vim.g.lazy_did_setup then return end

if not vim.loop.fs_stat(vim.g.plugin_manager) then
  -- install plugin manager if not already installed.
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    vim.g.plugin_manager_repo,
    '--branch=' .. vim.g.plugin_manager_branch,
    vim.g.plugin_manager,
  }
end

-- prepend the plugin manager to our runtime path.
vim.opt.rtp:prepend(vim.g.plugin_manager)

-- load the plugin manager with our plugin configurations.
require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    priority = 100,
    init = function() pcall(require('nvim-treesitter.install').update { with_sync = true }) end,
  },
  {
    'folke/which-key.nvim',
    init = function()
      local wk = require 'which-key'

      wk.register({
        e = { '<cmd>NeoTreeShowToggle<cr>', 'explore' },
        f = {
          name = 'file', -- optional group name
          f = { '<cmd>Telescope find_files<cr>', 'Find File' }, -- create a binding with label
          -- r = { '<cmd>Telescope oldfiles<cr>', 'Open Recent File', noremap = false, buffer = 123 }, -- additional options for creating the keymap
          n = { 'New File' }, -- just a label. don't create any mapping
          e = 'Edit File', -- same as above
          ['1'] = 'which_key_ignore', -- special label to hide it in the popup
          b = { function() print 'bar' end, 'Foobar' }, -- you can also pass functions!
        },
      }, { prefix = '<leader>' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    module = 'lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },
  { 'tpope/vim-fugitive', module = 'fugitive' },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      icons_enabled = false,
      -- theme = 'onedark',
      component_separators = '|',
      section_separators = '',
    },
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },
  { -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    config = true,
  },
  { -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    'onsails/lspkind.nvim',
    enable = not vim.g.icons,
    module = 'lspkind',
    dependencies = { 'neovim/nvim-lspconfig' },
  },

  { -- Parenthesis highlighting
    'p00f/nvim-ts-rainbow',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  { -- Autoclose tags
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  { -- Context based commenting
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'hrsh7th/nvim-cmp',
    -- lazy-load cmp on InsertEnter
    event = 'InsertEnter',
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- ...
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    config = true,
    event = 'UiEnter',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-tree/nvim-web-devicons' },
    opts = {
      filtered_items = {
        visible = true,
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          '.DS_Store',
          'thumbs.db',
          --"node_modules",
        },
        hide_by_pattern = {
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          '.gitignore',
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          '.DS_Store',
          'thumbs.db',
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
    },
  },
  { 'folke/neoconf.nvim', cmd = 'Neoconf' },
  { 'lewis6991/impatient.nvim', lazy = true },
  { 'github/copilot.vim', cmd = 'Copilot' },
  { 'b0o/SchemaStore.nvim', module = 'schemastore' },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    },
  },
  { 'folke/persistence.nvim', event = 'BufReadPre', module = 'persistence', config = true },
  { 'folke/neodev.nvim', config = true },
  { 'stevearc/dressing.nvim', event = 'VeryLazy' },

  {
    'nvim-neorg/neorg',
    ft = 'norg',
    config = true,
    opts = {},
  },

  {
    'catppuccin/nvim',
    module = 'catppuccin',
    event = 'UiEnter',
    config = function() vim.cmd 'colorscheme catppuccin-macchiato' end,
  },
}, {
  -- available options can be found in the README file:
  --   https://github.com/folke/lazy.nvim/tree/main#%EF%B8%8F-configuration
  root = vim.g.plugin_root,
  -- dev = { path = vim.g.plugin_root },
  performance = {
    rtp = {
      disabled_plugins = {
        'tutor',
        'tohtml',
        'matchparen',
        'matchit',
      },
    },
  },
})
