local lib = {}

function lib.insert_date()
  vim.api.nvim_feedkeys("i" .. tostring(require("os").date()), "n", true)
end

function lib.show_local_mappings()
  require("which-key").show({ global = false })
end

function lib.insert_time()
  vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%R"), "n", true)
end

function lib.insert_year()
  vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%Y"), "n", true)
end

function lib.set_shiftwidth()
  vim.ui.input(
    { prompt = "set shiftwidth " },
    function(input) vim.o.shiftwidth = tonumber(input) or vim.o.shiftwidth end
  )
end

function lib.toggle_conceal()
  vim.opt.conceallevel = vim.opt.conceallevel == 0 and 2 or 0
end

function lib.toggle_list()
  vim.bo.list = not vim.opt.list
end

function lib.toggle_paste()
  vim.bo.paste = not vim.opt.paste:get()
end

function lib.toggle_spell_check()
  vim.bo.spell = not vim.opt.spell
end

function lib.toggle_ruler()
  vim.wo.ruler = not vim.opt.ruler:get()
end


function lib.toggle_wrap() vim.wo.wrap = not vim.opt.wrap end

function lib.toggle_tabs_to_spaces()
  vim.ui.select({ "tabs", "spaces" }, {
    prompt = "Select tabs or spaces:",
    format_item = function(item) return "I'd like to use " .. item end,
  }, function(choice)
      if choice == "spaces" then
        vim.bo.expandtab = true
      else
        vim.bo.expandtab = false
      end
    end)
end

return {
  {
    "folke/which-key.nvim",
    lazy = true,
    enabled = true,
    event = "VeryLazy",
    cmd = { "WhichKey" },
    opts = {
      preset = "helix",
      show_help = true, -- show help message on the command line when the popup is visible
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      -- Disabled by deafult for Telescope
      disable = {
        -- disable the WhichKey popup for certain buf types.
        bt = {},
        -- disable the WhichKey popup for certain file types.
        ft = { "TelescopePrompt" },
      },
      -- Delay before showing the popup. Can be a number or a function that returns a number.
      ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          -- select spelling suggestions when pressing z=
          enabled = true,
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      win = {
        -- don't allow the popup to overlap with the cursor
        no_overlap = true,
        -- width = 1,
        -- height = { min = 4, max = 25 },
        -- col = 0,
        -- row = math.huge,
        -- border = "none",
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        title = true,
        title_pos = "center",
        zindex = 1000,
        -- Additional vim.wo and vim.bo options
        bo = {},
        wo = {
          winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      spec = {
        { "<C-s>", "<cmd>write<cr>", desc = "write buffer" },
        { "<c-w>\\", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, desc = "window mode" },
        { "<M-f>", group = "Find"},
        { "<leader><tab>", lib.toggle_tabs_to_spaces, desc = "tabs/spaces" },
        { "<leader>?", lib.show_local_mappings, desc = "local keymaps" },
        { "<leader>a", group = "Action" },
        { "<leader>b", group = "Buffer" },
        { "<leader>b?", lib.show_local_mappings, desc = "local keymaps" },
        { "<leader>bN", "<cmd>bnew<cr>", desc = "new buffer" },
        { "<leader>bd", "<cmd>bdelete<cr>", desc = "delete buffer" },
        { "<leader>be", "<cmd>enew<cr>", desc = "new scratch" },
        { "<leader>bn", "<cmd>bNext<cr>", desc = "next buffer" },
        { "<leader>bp", "<cmd>bprev<cr>", desc = "prev buffer" },
        { "<leader>bw", "<cmd>write<cr>", desc = "write buffer" },
        { "<leader>c", desc = "Toggle comment (line/visual)" },
        { "<leader>d", group = "Debugger" },
        { "<leader>db", function() require('dap').toggle_breakpoint() end, desc = "breakpoint" },
        { "<leader>dc", function() require('dap').continue() end, desc = "continue" },
        { "<leader>di", function() require('dap').step_into() end, desc = "step into" },
        { "<leader>do", function() require('dap').step_out() end, desc = "step out" },
        { "<leader>dn", function() require('dap').step_over() end, desc = "step over" },
        { "<leader>dr", function() require('dap').restart() end, desc = "restart" },
        { "<leader>de", function() require('dapui').eval(nil, { enter = true }) end, desc = "eval" },
        { "<leader>du", function() require('dapui').toggle() end, desc = "ui toggle" },
        { "<leader>e", "<cmd>Oil<cr>", desc = "explore" },
        { "<leader>f", group = "Find" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "live grep" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "help tags" },
        { "<leader>fo", "<cmd>Oil<cr>", desc = "file explorer" },
        { "<leader>g", group = "Git" },
        { "<leader>gg", "<cmd>Neogit kind=tab<cr>", desc = "git gui" },
        { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "git status" },
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "diff view" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "diff close" },
        { "<leader>h", group = "Help" },
        { "<leader>hL", "<cmd>help luaref-Lib<cr>", desc = "luaref-lib" },
        { "<leader>hM", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
        { "<leader>hN", "<cmd>help nvim.txt<cr>", desc = "nvim.txt" },
        { "<leader>hP", "<cmd>help lazy.nvim.txt<cr>", desc = "lazy.nvim" },
        { "<leader>hl", "<cmd>help lua.vim<cr>", desc = "lua.vim" },
        { "<leader>i", group = "Insert" },
        { "<leader>id", lib.insert_date, desc = "date" },
        { "<leader>it", lib.insert_time, desc = "time" },
        { "<leader>iy", lib.insert_year, desc = "year" },
        { "<leader>l", group = "LSP" },
        { "<leader>la", function() vim.lsp.buf.code_action() end, desc = "code action" },
        { "<leader>ld", function() vim.diagnostic.open_float() end, desc = "line diag" },
        { "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "format" },
        { "<leader>lh", function() vim.lsp.buf.hover() end, desc = "hover" },
        { "<leader>li", function() vim.lsp.buf.implementation() end, desc = "impl" },
        { "<leader>lr", function() vim.lsp.buf.rename() end, desc = "rename" },
        { "<leader>lR", function() vim.lsp.buf.references() end, desc = "references" },
        { "<leader>ls", function() vim.lsp.buf.document_symbol() end, desc = "doc symbols" },
        { "<leader>lS", function() vim.lsp.buf.workspace_symbol() end, desc = "ws symbols" },
        { "<leader>o", group = "Ollama" },
        { "<leader>p", group = "Project" },
        { "<leader>p/", "<cmd>Telescope find_files<cr>", desc = "find file" },
        { "<leader>pc", "<cmd>Neoconf<cr>", desc = "project config" },
        { "<leader>ps", function()
          local ok, persistence = pcall(require, "persistence")
          if ok then persistence.load() end
        end, desc = "session load" },
        { "<leader>pS", function()
          local ok, persistence = pcall(require, "persistence")
          if ok then persistence.load({ last = true }) end
        end, desc = "last session" },
        { "<leader>q", group = "Quickfix" },
        { "<leader>qq", "<cmd>copen<cr>", desc = "open quickfix" },
        { "<leader>qc", "<cmd>cclose<cr>", desc = "close quickfix" },
        { "<leader>qn", "<cmd>cnext<cr>", desc = "next qf" },
        { "<leader>qp", "<cmd>cprev<cr>", desc = "prev qf" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Tab" },
        { "<leader>tn", "<cmd>tabNext<cr>", desc = "next tab" },
        { "<leader>tp", "<cmd>tabprev<cr>", desc = "prev tab" },
        { "<leader>T", group = "Terminal" },
        { "<leader>Tt", "<cmd>ToggleTerm direction=float<cr>", desc = "float term" },
        { "<leader>z", group = "Toggle" },
        { "<leader>zc", lib.toggle_conceal, desc = "Toggle conceal" },
        { "<leader>zg", "<cmd>GitSignsToggle<cr>", desc = "Toggle git signs" },
        { "<leader>zl", lib.toggle_list, desc = "Toggle list" },
        { "<leader>zi", "<cmd>IndentGuidesToggle<cr>", desc = "Toggle guides" },
        { "<leader>zI", "<cmd>IndentDetect<cr>", desc = "Detect indent" },
        { "<leader>zo", "<cmd>SymbolsOutline<cr>", desc = "Toggle symbols" },
        { "<leader>zp", lib.toggle_paste, desc = "Toggle paste" },
        { "<leader>zr", lib.toggle_ruler, desc = "Toggle ruler" },
        { "<leader>zs", lib.toggle_spell_check, desc = "Toggle spell" },
        { "<leader>zw", lib.set_shiftwidth, desc = "Set shiftwidth" },
        { "<leader>zW", lib.toggle_wrap, desc = "Toggle wrap" },
      },
    },
  },
}
-- vim: fdl=1 fen fdm=expr
