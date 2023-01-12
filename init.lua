if vim.fn.has 'nvim-0.8' ~= 1 or vim.version().prerelease then
  vim.api.nvim_err_writeln(vim.tbl_concat({
    'Unsupported Neovim Version!',
    'Please ensure you have read the requirements carefully!',
  }, ' '))
end

-- install profiling, if we have the right things available.
local impatient_ok, impatient = pcall(require, 'impatient')
if impatient_ok then impatient.enable_profile() end

-- plugin manager configuration.
vim.g.mapleader = ' ' -- keep before most things so mappings are correct.
vim.g.plugin_root = vim.fn.stdpath 'data' .. '/lazy'
vim.g.plugin_manager = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
vim.g.plugin_manager_branch = 'stable'
vim.g.plugin_manager_repo = 'https://github.com/folke/lazy.nvim.git'

-- core neovim options
vim.opt.autoread = true
vim.opt.backspace = vim.opt.backspace + { 'nostop' } -- Don't stop backspace at insert
vim.opt.clipboard = 'unnamedplus' -- Connection to the system clipboard
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.completeopt = { 'menuone', 'noselect' } -- Options for insert mode completion
vim.opt.conceallevel = 2 -- enable conceal
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.expandtab = true -- Enable the use of space in tab
vim.opt.fileencoding = 'utf-8' -- File content encoding for the buffer
vim.opt.fillchars = { eob = ' ' } -- Disable `~` on nonexistent lines
vim.opt.foldenable = false
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()' -- set Treesitter based folding
vim.opt.foldlevelstart = 1
vim.opt.foldmethod = 'expr'
vim.opt.history = 100 -- Number of commands to remember in a history table
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.laststatus = 3 -- globalstatus
vim.opt.linebreak = true -- linebreak soft wrap at words
vim.opt.list = true -- show whitespace characters
vim.opt.listchars = { tab = '│→', extends = '⟩', precedes = '⟨', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a' -- Enable mouse support
vim.opt.number = true -- Show numberline
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.scrolloff = 8 -- Number of lines to keep above and below the cursor
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation
vim.opt.shortmess = vim.opt.shortmess + { I = true, s = true }
vim.opt.showbreak = '↪ '
vim.opt.showmode = false -- Disable showing modes in command line
vim.opt.showtabline = 2 -- always display tabline
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.opt.signcolumn = 'auto' -- sets vim.opt.signcolumn to auto
vim.opt.smartcase = true -- Case sensitivie searching
vim.opt.spell = false -- sets vim.opt.spell
vim.opt.spellfile = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'
vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.thesaurus = vim.fn.stdpath 'config' .. '/spell/thesaurus.txt'
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.wrap = false -- wrap long lines?
vim.opt.writebackup = false -- Disable making a backup before overwriting a file

-- ad-hoc configuration not tied to specific plugins.
if vim.fn.has 'neovide' then
  vim.g.neovide_cursor_animation_length = 0.025
  vim.g.neovide_cursor_trail_size = 0.05
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_vfx_mode = 'wireframe'
  vim.g.neovide_hide_mouse_when_typing = true
end
vim.g.autoformat_enabled = false -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
vim.g.cmp_enabled = true -- enable completion at start
vim.g.matchup_matchparen_deferred = 1
vim.g.autopairs_enabled = true -- enable autopairs at start
vim.g.diagnostics_enabled = true -- enable diagnostics at start

if not vim.g.lazy_did_setup then
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
      event = 'VeryLazy',
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
    { 'github/copilot.vim', enabled = false },
    { 'b0o/SchemaStore.nvim', module = 'schemastore' },
    { 'nvim-telescope/telescope.nvim', cmd = 'Telescope', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'folke/persistence.nvim', event = 'BufReadPre', module = 'persistence', config = true },
    { 'folke/neodev.nvim' },
    {
      'rebelot/heirline.nvim',
      event = 'UiEnter',
      opts = {},
    },

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
end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('yank', { clear = true }),
  pattern = '*',
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Reorder golang imports',
  group = vim.api.nvim_create_augroup('golang', { clear = true }),
  pattern = '*.go',
  callback = function()
    local wait_ms = 10
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})

vim.api.nvim_create_user_command('EchoFoo', function() vim.pretty_print 'foo' end, { desc = 'Echo foo' })
