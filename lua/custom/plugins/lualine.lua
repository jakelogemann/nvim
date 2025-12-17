return {
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
      local clients
      if vim.lsp and vim.lsp.get_clients then
        clients = vim.lsp.get_clients { bufnr = bufnr }
      else
        clients = vim.lsp.get_active_clients { bufnr = bufnr }
      end
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
}
