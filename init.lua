local utils = require "my.utils"

local function ensure_plugin_manager_installed()
  local plugin_manager = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(plugin_manager) then
    -- install plugin manager if not already installed.
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      plugin_manager,
    })
  end

  -- prepend the plugin manager to our runtime path.
  vim.opt.rtp:prepend(plugin_manager)
end

local function try_to_enable_profiler()
  -- use profiling, if available.
  local ok, profiler = pcall(require, "impatient")
  if ok then profiler.enable_profile() end
end

ensure_plugin_manager_installed()
utils.try_to_enable_profiler()

-- lazy.nvim can not be setup multiple times (which sucks).
if not vim.g.lazy_did_setup then 
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

require("my.options")
require("my.autocmds")
require("my.finder")
require("freeze").setup()
