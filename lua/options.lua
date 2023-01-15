-- core neovim options
vim.opt.autoread = true
vim.opt.backspace = vim.opt.backspace + { "nostop" } -- Don't stop backspace at insert
vim.opt.clipboard = "unnamedplus" -- Connection to the system clipboard
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
vim.opt.conceallevel = 2 -- enable conceal
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.expandtab = true -- Enable the use of space in tab
vim.opt.fileencoding = "utf-8" -- File content encoding for the buffer
vim.opt.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- set Treesitter based folding
vim.opt.foldlevelstart = 1
vim.opt.foldmethod = "expr"
vim.opt.history = 100 -- Number of commands to remember in a history table
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.laststatus = 3 -- globalstatus
vim.opt.linebreak = true -- linebreak soft wrap at words
vim.opt.list = true -- show whitespace characters
vim.opt.listchars = { tab = "│→", extends = "⟩", precedes = "⟨", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.number = true -- Show numberline
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pyxversion = 3 -- only use python3.
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.relativenumber = true -- Show relative numberline
vim.opt.scrolloff = 8 -- Number of lines to keep above and below the cursor
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation
vim.opt.shortmess = vim.opt.shortmess + { I = true, s = true }
vim.opt.showbreak = "↪ "
vim.opt.showmode = false -- Disable showing modes in command line
vim.opt.showtabline = 2 -- always display tabline
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.opt.signcolumn = "auto" -- sets vim.opt.signcolumn to auto
vim.opt.smartcase = true -- Case sensitivie searching
vim.opt.spell = false -- sets vim.opt.spell
vim.opt.spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
vim.opt.splitbelow = true -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.scrolljump = 1
vim.opt.thesaurus = vim.fn.stdpath "config" .. "/spell/thesaurus.txt"
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.wrap = false -- wrap long lines?
vim.opt.writebackup = false -- Disable making a backup before overwriting a file

-- ad-hoc configuration not tied to specific plugins.
if vim.fn.has "neovide" then
  vim.g.neovide_cursor_animation_length = 0.025
  vim.g.neovide_cursor_trail_size = 0.05
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_hide_mouse_when_typing = true
end

vim.g.treesitter_parsers_dir = vim.fn.stdpath "data" .. "/parsers"
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autoformat_enabled = false -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
vim.g.cmp_enabled = true -- enable completion at start
vim.g.matchup_matchparen_deferred = 1
vim.g.autopairs_enabled = true -- enable autopairs at start
vim.g.diagnostics_enabled = true -- enable diagnostics at start
