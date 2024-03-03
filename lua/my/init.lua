-- Loads my configuration specfied below...
-- install profiling, if available.
local ok, profiler = pcall(require, "impatient")
if ok then profiler.enable_profile() end

require "my.options"

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
  require("lazy").setup(require "my.plugins", {
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

require "my.autocmds"
require "my.commands"
require "my.toggle"
require "my.finder"
require "my.mappings"
