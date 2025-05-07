local utils = require "custom.utils"
local plugin_dir = vim.fn.stdpath "data" .. "/lazy"
local plugin_manager_root = plugin_dir .. "/lazy.nvim"
local plugin_manager_options = {
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
}

local function setup_plugin_manager()
  if not vim.loop.fs_stat(plugin_manager_root) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      plugin_manager_root,
    }
  end

  if not vim.g.lazy_did_setup then
    -- since lazy can bind keys, we need to set the leader key before we load it.
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    -- prepend the plugin manager to our runtime path.
    vim.opt.rtp:prepend(plugin_manager_root)

    require("lazy").setup("custom/plugins", plugin_manager_options)
  end
end



setup_plugin_manager()
utils.try_to_enable_profiler()
require("freeze").setup()
require("custom.welcome").setup()
