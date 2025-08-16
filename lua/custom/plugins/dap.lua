return {
  "mfussenegger/nvim-dap",
  lazy = false,
  dependencies = {
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
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
    local ui = require "dapui"

    require("dapui").setup()
    require("dap-go").setup()

    require("nvim-dap-virtual-text").setup {
      -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
      display_callback = function(variable)
        local name = string.lower(variable.name)
        local value = string.lower(variable.value)
        if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then return "*****" end

        if #variable.value > 15 then return " " .. string.sub(variable.value, 1, 15) .. "... " end

        return " " .. variable.value
      end,
    }

    -- Handled by nvim-dap-go
    -- dap.adapters.go = {
    --   type = "server",
    --   port = "${port}",
    --   executable = {
    --     command = "dlv",
    --     args = { "dap", "-l", "127.0.0.1:${port}" },
    --   },
    -- }

    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end
  end,
}
