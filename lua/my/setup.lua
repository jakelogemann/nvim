local setup = {}

function setup.ensure_plugin_manager_installed()
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
function setup.plugin_manager()
  -- lazy.nvim can not be setup multiple times (which sucks).
  if vim.g.lazy_did_setup then return end

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

function setup.try_to_enable_profiler()
  -- use profiling, if available.
  local ok, profiler = pcall(require, "impatient")
  if ok then profiler.enable_profile() end
end

function setup.init()
  setup.ensure_plugin_manager_installed()
  setup.plugin_manager()
  setup.try_to_enable_profiler()

  require "my.options"
  require "my.autocmds"
  require "my.commands"
  require "my.toggle"
  require "my.finder"
  require "my.mappings"

  return
end

return setup
