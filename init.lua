local function ensure_plugin_manager_installed()
  if not vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") then
    -- install plugin manager if not already installed.
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
    })
  end
end



ensure_plugin_manager_installed()
if not vim.g.lazy_did_setup then
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
