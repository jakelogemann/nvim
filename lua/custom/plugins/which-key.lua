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
      delay = function(ctx) return ctx.plugin and 0 or 200 end,
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
        { "<c-w>\\", function() require("which-key").show { keys = "<c-w>", loop = true } end, desc = "window mode" },
        { "<M-f>", group = "Find" },
        { "<leader><leader>", "<c-^>", desc = "alternate buffer" },
        {
          "<leader><tab>",
          function()
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
          end,
          desc = "tabs/spaces",
        },
        { "<leader>?", function() require("which-key").show { global = false } end, desc = "local keymaps" },
        { "<leader>a", group = "Action" },
        { "<leader>b", group = "Buffer" },
        { "<leader>b?", function() require("which-key").show { global = false } end, desc = "local keymaps" },
        { "<leader>bN", "<cmd>bnew<cr>", desc = "new buffer" },
        { "<leader>bd", "<cmd>bdelete<cr>", desc = "delete buffer" },
        { "<leader>be", "<cmd>enew<cr>", desc = "new scratch" },
        { "<leader>bn", "<cmd>bNext<cr>", desc = "next buffer" },
        { "<leader>bp", "<cmd>bprev<cr>", desc = "prev buffer" },
        { "<leader>bw", "<cmd>write<cr>", desc = "write buffer" },
        { "<leader>c", desc = "Toggle comment (line/visual)" },
        { "<leader>d", group = "Debugger" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "continue" },
        { "<leader>di", function() require("dap").step_into() end, desc = "step into" },
        { "<leader>do", function() require("dap").step_out() end, desc = "step out" },
        { "<leader>dn", function() require("dap").step_over() end, desc = "step over" },
        { "<leader>dr", function() require("dap").restart() end, desc = "restart" },
        { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, desc = "eval" },
        { "<leader>du", function() require("dapui").toggle() end, desc = "ui toggle" },
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
        {
          "<leader>id",
          function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date()), "n", true) end,
          desc = "date",
        },
        {
          "<leader>it",
          function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%R"), "n", true) end,
          desc = "time",
        },
        {
          "<leader>iy",
          function() vim.api.nvim_feedkeys("i" .. tostring(require("os").date "%Y"), "n", true) end,
          desc = "year",
        },
        { "<leader>l", group = "LSP" },
        { "<leader>la", function() vim.lsp.buf.code_action() end, desc = "code action" },
        { "<leader>ld", function() vim.diagnostic.open_float() end, desc = "line diag" },
        { "<leader>lf", function() vim.lsp.buf.format { async = true } end, desc = "format" },
        { "<leader>lh", function() vim.lsp.buf.hover() end, desc = "hover" },
        { "<leader>li", function() vim.lsp.buf.implementation() end, desc = "impl" },
        { "<leader>lr", function() vim.lsp.buf.rename() end, desc = "rename" },
        { "<leader>lR", function() vim.lsp.buf.references() end, desc = "references" },
        { "<leader>ls", function() vim.lsp.buf.document_symbol() end, desc = "doc symbols" },
        { "<leader>lS", function() vim.lsp.buf.workspace_symbol() end, desc = "ws symbols" },
        { "<leader>o", group = "Ollama" },
        -- Ollama prompt shortcuts (normal or visual)
        {
          "<leader>op",
          function() vim.cmd((vim.fn.mode():match "[vV]" and "'<,'>") .. "Ollama") end,
          desc = "Ollama prompt",
        },
        {
          "<leader>oc",
          function() vim.cmd((vim.fn.mode():match "[vV]" and "'<,'>") .. "Ollama Change_Code") end,
          desc = "Change code",
        },
        {
          "<leader>oe",
          function() vim.cmd((vim.fn.mode():match "[vV]" and "'<,'>") .. "Ollama Enhance_Code") end,
          desc = "Enhance code",
        },
        {
          "<leader>or",
          function() vim.cmd((vim.fn.mode():match "[vV]" and "'<,'>") .. "Ollama Review_Code") end,
          desc = "Review code",
        },
        {
          "<leader>os",
          function() vim.cmd((vim.fn.mode():match "[vV]" and "'<,'>") .. "Ollama Summarize") end,
          desc = "Summarize",
        },
        {
          "<leader>om",
          function()
            local ok, o = pcall(require, "ollama")
            if ok and o.select_model then
              o.select_model()
            else
              vim.notify("No model selector", "warn")
            end
          end,
          desc = "Model select",
        },
        { "<leader>ox", function() vim.cmd "Ollama" end, desc = "Pick prompt" },

        -- Copilot group
        { "<leader>C", group = "Copilot" },
        { "<leader>Ce", function() vim.cmd "Copilot enable" end, desc = "enable" },
        { "<leader>Cd", function() vim.cmd "Copilot disable" end, desc = "disable" },
        { "<leader>Cs", function() vim.cmd "Copilot status" end, desc = "status" },
        { "<leader>Cp", function() vim.cmd "Copilot panel" end, desc = "panel" },
        {
          "<leader>Ca",
          function()
            -- Accept suggestion (simulate <M-CR>)
            local keys = vim.api.nvim_replace_termcodes("<M-CR>", true, false, true)
            vim.api.nvim_feedkeys(keys, "i", false)
          end,
          desc = "accept suggestion",
        },
        {
          "<leader>CT",
          function()
            if vim.g.copilot_enabled == 1 then
              vim.cmd "Copilot disable"
            else
              vim.cmd "Copilot enable"
            end
          end,
          desc = "toggle",
        },

        -- Rust utilities (assuming cargo project)
        { "<leader>r", group = "Rust" },
        { "<leader>rt", function() require("custom.utils").run_in_term "cargo test" end, desc = "cargo test" },
        {
          "<leader>rf",
          function()
            local file = vim.fn.expand "%"
            require("custom.utils").run_in_term("cargo test -- " .. file)
          end,
          desc = "test file",
        },
        { "<leader>rr", function() require("custom.utils").run_in_term "cargo run" end, desc = "cargo run" },
        { "<leader>rb", function() require("custom.utils").run_in_term "cargo build" end, desc = "cargo build" },

        -- Go (vim-go commands)
        { "<leader>G", group = "Go" },
        { "<leader>Gt", function() vim.cmd "GoTest" end, desc = "test package" },
        { "<leader>GF", function() vim.cmd "GoTestFunc" end, desc = "test func" },
        { "<leader>Gf", function() vim.cmd "GoTestFile" end, desc = "test file" },
        { "<leader>Gb", function() vim.cmd "GoBuild" end, desc = "build" },
        { "<leader>Gi", function() vim.cmd "GoInstall" end, desc = "install" },

        -- Execute current file (shell / script / single-file run)
        { "<leader>x", group = "Execute" },
        {
          "<leader>xx",
          function()
            local ft = vim.bo.filetype
            local file = vim.fn.expand "%:p"
            local cmd
            if ft == "go" then
              cmd = "go run " .. file
            elseif ft == "rust" then
              cmd = "cargo run"
            elseif ft == "python" then
              cmd = "python " .. file
            elseif ft == "sh" or ft == "bash" or ft == "zsh" or ft == "fish" then
              cmd = file
            else
              cmd = file
            end
            local ok, u = pcall(require, "custom.utils")
            if ok and u.run_in_term then
              u.run_in_term(cmd)
            else
              vim.cmd("!" .. cmd)
            end
          end,
          desc = "run file",
        },

        -- Editing utilities
        { "<leader>y", group = "Yank/dup" },
        { "<leader>yd", function() vim.cmd "t." end, desc = "duplicate line" },
        {
          "<leader>sS",
          function()
            local w = vim.fn.expand "<cword>"
            vim.cmd("%%s/\\<" .. w .. "\\>//gI")
          end,
          desc = "substitute word",
        },
        { "<leader>m", group = "Move" },
        { "<leader>mj", function() vim.cmd "move .+1 | normal ==" end, desc = "line down" },
        { "<leader>mk", function() vim.cmd "move .-2 | normal ==" end, desc = "line up" },
        { "<leader>sw", function() vim.cmd "set list!" end, desc = "toggle invisibles" },
        { "<leader>sg", function() vim.cmd "Telescope grep_string" end, desc = "grep word" },
        { "<leader>p", group = "Project" },
        { "<leader>p/", "<cmd>Telescope find_files<cr>", desc = "find file" },
        { "<leader>pc", "<cmd>Neoconf<cr>", desc = "project config" },
        {
          "<leader>ps",
          function()
            local ok, persistence = pcall(require, "persistence")
            if ok then persistence.load() end
          end,
          desc = "session load",
        },
        {
          "<leader>pS",
          function()
            local ok, persistence = pcall(require, "persistence")
            if ok then persistence.load { last = true } end
          end,
          desc = "last session",
        },
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
        {
          "<leader>zc",
          function() vim.opt.conceallevel = vim.opt.conceallevel == 0 and 2 or 0 end,
          desc = "Toggle conceal",
        },
        { "<leader>zg", "<cmd>GitSignsToggle<cr>", desc = "Toggle git signs" },
        { "<leader>zl", function() vim.bo.list = not vim.bo.list end, desc = "Toggle list" },
        { "<leader>zi", "<cmd>IndentGuidesToggle<cr>", desc = "Toggle guides" },
        { "<leader>zI", "<cmd>IndentDetect<cr>", desc = "Detect indent" },
        { "<leader>zo", "<cmd>SymbolsOutline<cr>", desc = "Toggle symbols" },
        { "<leader>zp", function() vim.o.paste = not vim.o.paste end, desc = "Toggle paste" },
        { "<leader>zr", function() vim.wo.ruler = not vim.wo.ruler end, desc = "Toggle ruler" },
        { "<leader>zs", function() vim.bo.spell = not vim.bo.spell end, desc = "Toggle spell" },
        {
          "<leader>zw",
          function()
            vim.ui.input({ prompt = "set shiftwidth " }, function(input)
              local n = tonumber(input)
              if n then vim.o.shiftwidth = n end
            end)
          end,
          desc = "Set shiftwidth",
        },
        { "<leader>zW", function() vim.wo.wrap = not vim.wo.wrap end, desc = "Toggle wrap" },
      },
    },
  },
}
-- vim: fdl=1 fen fdm=expr
