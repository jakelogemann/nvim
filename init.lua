if not vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") then
  -- installs the "lazy" plugin manager if its not already installed.
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  })
end

if not vim.g.lazy_did_setup then
  -- since lazy can bind keys, we need to set the leader key before we load it.
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  -- prepend the plugin manager to our runtime path.
  vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

  require("lazy").setup("custom/plugins", {
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

require("custom.utils").try_to_enable_profiler()
require("freeze").setup()
