--- Core Neovim option initialization.
-- Guarded to run only once; sets UI, editing, performance, and provider flags.
-- Adjust values here for global behavior tweaks.
-- Prevent double application (lazy may re-source this when new plugins load)
if vim.g._core_options_applied then return end
vim.g._core_options_applied = true
--vim.opt.wildchar = "<Tab>"
vim.opt.autoread = true
vim.opt.inccommand = "split"
vim.opt.shada = { "'10", "<0", "s10", "h" }
vim.opt.backspace = vim.opt.backspace + { "nostop" } -- Don't stop backspace at insert
vim.opt.backupdir:remove('.') -- keep backups out of the current directory
vim.opt.clipboard = "unnamedplus" -- Connection to the system clipboard
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.completeopt = { "menuone", "noselect" } -- Options for insert mode completion
vim.opt.conceallevel = 2 -- enable conceal
vim.opt.confirm = true -- ask for confirmation instead of erroring
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.expandtab = true -- Enable the use of space in tab
vim.opt.exrc = true
-- Use global variant to avoid errors when current buffer is unmodifiable (welcome screen / special bufs)
vim.o.fileencoding = "utf-8" -- Default file content encoding
vim.opt.fillchars = { eob = " " } -- Disable `~` on nonexistent lines
vim.opt.foldenable = false
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- set Treesitter based folding
vim.opt.foldlevel = 0
vim.opt.foldmethod = "expr"
vim.opt.formatoptions:remove {"o"}
vim.opt.history = 100 -- Number of commands to remember in a history table
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.laststatus = 3 -- globalstatus
vim.opt.linebreak = true -- linebreak soft wrap at words
vim.opt.list = true -- show whitespace characters
vim.opt.listchars.extends = "⟩"
vim.opt.listchars.nbsp = "␣"
vim.opt.listchars.precedes = "⟨"
vim.opt.listchars.tab = "│→"
vim.opt.listchars.trail = "·"
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.mousemoveevent = true -- Allow hovering in bufferline
vim.opt.number = true -- Show numberline
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.pyxversion = 3 -- only use python3.
vim.opt.relativenumber = false
vim.opt.scrolljump = 1
vim.opt.scrolloff = 8 -- Number of lines to keep above and below the cursor
vim.opt.secure = true
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation
vim.opt.shortmess.I = true -- disables the splash screen on startup
vim.opt.shortmess.s = true
vim.opt.showbreak = "↪ "
vim.opt.showmode = false
vim.opt.showmode = false -- Disable showing modes in command line
vim.opt.showtabline = 2 -- always display tabline
vim.opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
vim.opt.signcolumn = "yes:2" -- sets vim.opt.signcolumn to auto
vim.opt.smartcase = true -- Case sensitivie searching
vim.opt.spell = false -- sets vim.opt.spell
vim.opt.spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
vim.opt.splitbelow = false -- Splitting a new window below the current one
vim.opt.splitright = true -- Splitting a new window at the right of the current one
vim.opt.tabstop = 2 -- Number of space in a tab
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.thesaurus = vim.fn.stdpath "config" .. "/spell/thesaurus.txt"
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- Length of time to wait for a mapped sequence
vim.opt.title = true
vim.opt.titlestring = '%f // nvim'
vim.opt.undofile = true -- Enable persistent undo
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin
vim.opt.wildmenu = true
vim.opt.wrap = false -- wrap long lines?
vim.opt.writebackup = false -- Disable making a backup before overwriting a file

-- ad-hoc configuration not tied to specific plugins.
if vim.g.neovide then
  vim.opt.guifont = "DaddyTimeMono Nerd Font:h13"
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_scale_factor = 0.98
  vim.g.neovide_cursor_animation_length = 0.025
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_short_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.01
  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_position_animation_length = 0.0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 60 
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_left = 1
  vim.g.neovide_padding_right = 0
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_padding_top = 1
  vim.g.neovide_show_border = false
  vim.g.neovide_opacity = 0.95
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_window_blurred = true
  -- vim.keymap.set("n", "<C-=>", function()
  --   vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.25
  -- end)
  -- vim.keymap.set("n", "<C-->", function()
  --   vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * (1/1.25)
  -- end)
end

vim.g.treesitter_parsers_dir = vim.fn.stdpath "data" .. "/parsers"
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autoformat_enabled = false -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
vim.g.cmp_enabled = true -- enable completion at start
vim.g.matchup_matchparen_deferred = 1
vim.g.autopairs_enabled = true -- enable autopairs at start
vim.g.diagnostics_enabled = true -- enable diagnostics at start
vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
vim.g.icons = true
