return {
  {
    "nvim-lualine/lualine.nvim",
    -- simplistic lua statusline plugin.
    lazy = false,
    enabled = true,
    module = "lualine",
    dependencies = {
      "catppuccin/nvim",
      "tjdevries/colorbuddy.nvim",
      "folke/lazy.nvim",
    },
    opts = function()
      -- Custom lightweight components -------------------------------
      local function lsp_clients()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        if #clients == 0 then return "" end
        local names = {}
        for _, c in ipairs(clients) do
          if c.name ~= "null-ls" then table.insert(names, c.name) end
        end
        if #names == 0 then return "" end
        local text = table.concat(names, ",")
        if #text > 20 then text = text:sub(1, 17) .. "…" end
        return " " .. text
      end

      local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      local function lsp_progress()
        local msgs = vim.lsp.util.get_progress_messages()
        if not msgs or #msgs == 0 then return "" end
        local msg = msgs[1]
        local pct = msg.percentage and (msg.percentage .. "% ") or ""
        local frame = math.floor((vim.loop.hrtime() / 1e8) % #spinner_frames) + 1
        local title = msg.title or msg.message or ""
        return spinner_frames[frame] .. " " .. pct .. title
      end

      local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg == "" then return "" end
        return " @" .. reg
      end

      local function searchcount_component()
        if vim.v.hlsearch == 0 then return "" end
        local sc = vim.fn.searchcount { recompute = 0, maxcount = 9999 }
        if not sc or sc.total == 0 then return "" end
        return string.format(" %d/%d", sc.current, sc.total)
      end

      local function venv()
        local v = vim.env.VIRTUAL_ENV
        if not v or v == "" then return "" end
        local name = vim.fn.fnamemodify(v, ":t")
        return " " .. name
      end

      local function ollama_status()
        local ok, o = pcall(require, "ollama")
        if not ok then return "" end
        local status = o.status and o.status() or nil
        if status == "IDLE" then return "󱙺" end
        if status == "WORKING" then return "󰚩" end
        return ""
      end

      -- Extensions: remove unused neo-tree (not installed), add lazy & dap-ui if available.
      local extensions = {
        "fugitive",
        "fzf",
        "man",
        "quickfix",
        "symbols-outline",
        "toggleterm",
        "lazy",
      }
      -- Add nvim-dap-ui extension if module exists
      if pcall(require, "dap") then table.insert(extensions, "nvim-dap-ui") end

      return {
        options = {
          icons_enabled = true,
          theme = "auto",
          extensions = extensions,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = {}, winbar = {} },
          ignore_focus = {},
          -- Use globalstatus? Keep false for lightweight isolation.
          always_divide_middle = true,
          globalstatus = false,
          refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = {
            "encoding", -- keep one file meta (dropped fileformat to save space)
            "filetype",
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = { fg = "ff9e64" } },
            venv,
            lsp_clients,
            lsp_progress,
            ollama_status,
          },
          lualine_y = { searchcount_component, macro_recording, "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },

  {
    "folke/noice.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "Noice" },
    main = "noice",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      lsp = {
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        cmdline_output_to_split = false,
        inc_rename = true,
        lsp_doc_border = false,
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
      cmdline = {
        format = {
          search_down = {
            view = "cmdline",
          },
          search_up = {
            view = "cmdline",
          },
        },
      },
    },
  },

  { -- fast, minimal fuzzy finder for.. everything.
    "nvim-telescope/telescope.nvim",
    lazy = true,
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<f1>", "<cmd>Telescope help_tags<cr>", desc = "help tags" },
      { "<leader>b/", "<cmd>Telescope buffers<cr>", desc = "buffers search" },
      { "<leader>f/", "<cmd>Telescope live_grep<cr>", desc = "file search" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
      { "<leader>h/", "<cmd>Telescope help_tags<cr>", desc = "help search" },
      { "<M-Space><M-Space>", "<cmd>Telescope<cr>", desc = "telescope" },
      { "<M-f><M-f>", "<cmd>Telescope<cr>", desc = "find anything" },
      { "<M-f>/", "<cmd>Telescope builtin<cr>", desc = "find builtins" },
      { "<M-f>`", "<cmd>Telescope marks<cr>", desc = "find marks" },
      { "<M-f>b", "<cmd>Telescope buffer<cr>", desc = "find buffers" },
      { "<M-f>d", "<cmd>Telescope diagnostics<cr>", desc = "find diagnostics" },
      { "<M-f>f", "<cmd>Telescope find_files<cr>", desc = "find files" },
      { "<M-f>h", "<cmd>Telescope help_tags<cr>", desc = "find help_tags" },
      { "<M-f>l", "<cmd>Telescope loclist<cr>", desc = "find loclist" },
      { "<M-f>m", "<cmd>Telescope man_pages<cr>", desc = "find man pages" },
      { "<M-f>q", "<cmd>Telescope quickfix<cr>", desc = "find quickfix" },
      { "<M-f>t", "<cmd>Telescope treesitter<cr>", desc = "find treesitter" },
      { "<M-f>c", "<cmd>Telescope commands<cr>", desc = "find commands" },
    },
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          bottom_pane = {
            height = 25,
            preview_cutoff = 120,
            prompt_position = "top",
          },
          center = {
            height = 0.4,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.5,
          },
          cursor = {
            height = 0.9,
            preview_cutoff = 40,
            width = 0.8,
          },
          horizontal = {
            height = 0.9,
            preview_cutoff = 120,
            prompt_position = "bottom",
            width = 0.8,
          },
          vertical = {
            height = 0.9,
            preview_cutoff = 40,
            prompt_position = "bottom",
            width = 0.8,
          },
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
  },
}
-- vim: fdl=1 fen fdm=expr
