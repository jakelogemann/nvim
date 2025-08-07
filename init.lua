local utils = require "custom.utils"
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

plugin_manager.setup = function()
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
