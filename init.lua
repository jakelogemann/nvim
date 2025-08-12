local utils = require "custom.utils"

--- Lazy plugin manager bootstrap descriptor.
-- Ensures lazy.nvim is cloned then initializes with provided performance options.
-- @class PluginManager
-- @field name string repository folder name
-- @field dir string base install path (stdpath('data') .. '/lazy')
-- @field options table passed to require('lazy').setup
local plugin_manager = {
  name = "lazy.nvim",
  dir = vim.fn.stdpath "data" .. "/lazy",
  options = {
    diff = {
      cmd = "diffview.nvim",
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "tutor",
          "tohtml",
          "matchparen",
          "netrw",
          "matchit",
        },
      },
    },
  },
}

--- Bootstrap and configure lazy.nvim if not already initialized.
-- Safe to call multiple times; subsequent calls are no-ops once `lazy_did_setup` is set.
function plugin_manager.setup()
  local root = plugin_manager.dir .. "/" .. plugin_manager.name
  if not vim.loop.fs_stat(root) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      root,
    }
  end

  if not vim.g.lazy_did_setup then
    -- since lazy can bind keys, we need to set the leader key before we load it.
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    -- prepend the plugin manager to our runtime path.
    vim.opt.rtp:prepend(root)

    require("lazy").setup("custom/plugins", plugin_manager.options)
  end
end


plugin_manager.setup()
utils.try_to_enable_profiler()
require("freeze").setup()
require("custom.comment").setup()
