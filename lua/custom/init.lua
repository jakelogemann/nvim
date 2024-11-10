local plugin_root =  vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function clone_plugin_manager()
  if vim.loop.fs_stat(plugin_root) then return end
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    plugin_root,
  })
end

local function setup_plugin_manager()
  if not vim.g.lazy_did_setup then
    -- since lazy can bind keys, we need to set the leader key before we load it.
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    -- prepend the plugin manager to our runtime path.
    vim.opt.rtp:prepend(plugin_root)

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
  require("custom.welcome").setup()
end

local function setup()
  clone_plugin_manager()
  setup_plugin_manager()
end

return {
  setup = setup,
}
