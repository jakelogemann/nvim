local utils = require "my.utils"

local function ensure_plugin_manager_installed()
  local plugin_root = vim.fn.stdpath "config" .. "/vendor"
  local plugin_manager = vim.fn.stdpath "config" .. "/vendor/lazy.nvim"
  if not vim.loop.fs_stat(plugin_manager) then
    -- install plugin manager if not already installed.
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      plugin_manager,
    }
  end

  -- prepend the plugin manager to our runtime path.
  vim.opt.rtp:prepend(plugin_manager)
end

-- plugin manager configuration.
local function plugin_manager()
  -- lazy.nvim can not be setup multiple times (which sucks).
  if vim.g.lazy_did_setup then return end

  -- load the plugin manager with our plugin configurations.
  require("lazy").setup(require("my.plugins"), {
    diff = {
      cmd = "diffview.nvim",
    },
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
  })
end

local function try_to_enable_profiler()
  -- use profiling, if available.
  local ok, profiler = pcall(require, "impatient")
  if ok then profiler.enable_profile() end
end

return function()
  ensure_plugin_manager_installed()
  try_to_enable_profiler()
  plugin_manager()

  require "my.options"
  require "my.autocmds"
  require "my.finder"
end
