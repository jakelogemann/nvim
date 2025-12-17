return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    { "leoluz/nvim-dap-go", module = "dap-go" },
    { "rcarriga/nvim-dap-ui", module = "dapui" },
    { "theHamsta/nvim-dap-virtual-text", module = "nvim-dap-virtual-text" },
    { "nvim-neotest/nvim-nio", lazy = true },
  },

  keys = {
    { "<F1>", function() require("dap").continue() end, desc = "dap: continue" },
    { "<F2>", function() require("dap").step_into() end, desc = "dap: step into" },
    { "<F3>", function() require("dap").step_over() end, desc = "dap: step over" },
    { "<F4>", function() require("dap").step_out() end, desc = "dap: step out" },
    { "<F5>", function() require("dap").step_back() end, desc = "dap: step back" },
    { "<F13>", function() require("dap").restart() end, desc = "dap: restart" },
    { "<space>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<space>gb", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<space>?", function() require("dapui").eval(nil, { enter = true }) end, desc = "dap: eval" },
  },
  config = function()
    local dap = require "dap"

    local _ui_ready, _vt_ready, _go_ready = false, false, false
    local function ensure_ui()
      if _ui_ready then return end
      local ok_ui, dapui = pcall(require, "dapui")
      if ok_ui then dapui.setup() end
      _ui_ready = ok_ui
    end
    local function ensure_vt()
      if _vt_ready then return end
      local ok_vt, vt = pcall(require, "nvim-dap-virtual-text")
      if ok_vt then
        vt.setup {
          display_callback = function(variable)
            local name = string.lower(variable.name)
            local value = string.lower(variable.value)
            if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then return "*****" end
            if #variable.value > 15 then return " " .. string.sub(variable.value, 1, 15) .. "... " end
            return " " .. variable.value
          end,
        }
      end
      _vt_ready = ok_vt
    end
    local function ensure_go()
      if _go_ready then return end
      local ok_go, dgo = pcall(require, "dap-go")
      if ok_go then dgo.setup() end
      _go_ready = ok_go
    end

    -- Initialize Go adapter when editing Go files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = ensure_go,
    })

    -- UI open/close on dap lifecycle, initialized on first use
    dap.listeners.before.attach.dapui_config = function()
      ensure_ui()
      ensure_vt()
      local ok, dapui = pcall(require, "dapui")
      if ok then dapui.open() end
    end
    dap.listeners.before.launch.dapui_config = function()
      ensure_ui()
      ensure_vt()
      local ok, dapui = pcall(require, "dapui")
      if ok then dapui.open() end
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      local ok, dapui = pcall(require, "dapui")
      if ok then dapui.close() end
    end
    dap.listeners.before.event_exited.dapui_config = function()
      local ok, dapui = pcall(require, "dapui")
      if ok then dapui.close() end
    end
  end,
}
