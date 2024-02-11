-- install profiling, if available.
local ok, profiler = pcall(require, "impatient")
if ok then profiler.enable_profile() end

-- NeoVim Application Options {{{1
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
vim.opt.foldlevel = 0
vim.opt.foldmethod = "expr"
vim.opt.history = 100 -- Number of commands to remember in a history table
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.laststatus = 3 -- globalstatus
vim.opt.linebreak = true -- linebreak soft wrap at words
vim.opt.list = true -- show whitespace characters
vim.opt.listchars.nbsp = "␣"
vim.opt.listchars.trail = "·"
vim.opt.listchars.precedes = "⟨"
vim.opt.listchars.tab = nil -- "│→"
vim.opt.listchars.extends = "⟩"
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.number = true -- Show numberline
vim.opt.relativenumber = false
vim.opt.preserveindent = true -- Preserve indent structure as much as possible
vim.opt.pyxversion = 3 -- only use python3.
vim.opt.pumheight = 10 -- Height of the pop up menu
vim.opt.scrolloff = 8 -- Number of lines to keep above and below the cursor
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation
vim.opt.shortmess.I = true
vim.opt.shortmess.s = true
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
vim.opt.guifont = "DaddyTimeMono NerdFont:h13"
--vim.opt.wildchar = "<Tab>"
vim.opt.wildmenu = true
-- End of NeoVim Options 1}}}
-- Global NeoVim Variables {{{1
-- ad-hoc configuration not tied to specific plugins.
if vim.fn.has "neovide" == 1 then
  vim.print "detected this is NeoVide"
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
vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
-- End of Global NeoVim Variables 1}}}
-- User-defined Commands {{{1
vim.api.nvim_create_user_command("ToggleLineNumbers", function()
  local ln = vim.opt.number:get()
  vim.wo.number = not ln
  vim.wo.relativenumber = ln
end, {
  desc = "toggle line numbers in the current buffer",
})
-- End of User-defined Commands 1}}}
-- User-defined autocommands {{{1
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("yank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Reorder golang imports",
  group = vim.api.nvim_create_augroup("golang", { clear = true }),
  pattern = "*.go",
  callback = function()
    local wait_ms = 10
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Automatically Format",
  group = vim.api.nvim_create_augroup("autoformat", { clear = true }),
  pattern = { "*.lua", "*.json", "*.go", "*.ts", "*.js" },
  callback = function() vim.cmd "Format" end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "setup terminal",
  group = vim.api.nvim_create_augroup("terminal", { clear = true }),
  pattern = "term://*",
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "setup oil buffers",
  group = vim.api.nvim_create_augroup("oil-buf", { clear = true }),
  pattern = "Oil://*",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})
-- End of User-defined Autocommands 1}}}
-- Plugin Manager {{{1
-- plugin manager configuration.
vim.g.plugin_root = vim.fn.stdpath "config" .. "/vendor"
vim.g.plugin_manager = vim.fn.stdpath "config" .. "/vendor/lazy.nvim"
vim.g.plugin_manager_branch = "stable"
vim.g.plugin_manager_repo = "https://github.com/folke/lazy.nvim.git"

if not vim.loop.fs_stat(vim.g.plugin_manager) then
  -- install plugin manager if not already installed.
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    vim.g.plugin_manager_repo,
    "--branch=" .. vim.g.plugin_manager_branch,
    vim.g.plugin_manager,
  }
end

if not vim.g.lazy_did_setup then
  -- lazy.nvim can not be setup multiple times (which sucks).

  -- prepend the plugin manager to our runtime path.
  vim.opt.rtp:prepend(vim.g.plugin_manager)

  -- load the plugin manager with our plugin configurations.
  require("lazy").setup(require "plugins", plugin_manager_options)
end

-- Options passed to the plugin manager.
--  available options can be found in the README file:
--  https://github.com/folke/lazy.nvim/tree/main#%EF%B8%8F-configuration
local plugin_manager_options = {
  defaults = {
    lazy = false,
    version = "*",
  },
  root = vim.g.plugin_root,
  diff = { cmd = "diffview.nvim" },
  performance = {
    rtp = {
      disabled_plugins = {
        "tutor",
        "tohtml",
        "matchparen",
        "matchit",
      },
    },
  },
}
require "plugins"
-- End of Plugin Manager }}}1
require "toggle"
require "finder"
require "mappings"

-- vim: fdm=marker fen
