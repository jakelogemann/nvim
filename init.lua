if vim.fn.has "nvim-0.8" ~= 1 or vim.version().prerelease then
  vim.api.nvim_err_writeln(vim.tbl_concat({
    "Unsupported Neovim Version!",
    "Please ensure you have read the requirements carefully!",
  }, " "))
end

-- install profiling, if available.
local ok, profiler = pcall(require, "impatient")
if ok then profiler.enable_profile() end

require "options"
require "plugins"
require "autocmds"
require "commands"
require "mappings"
