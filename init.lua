if vim.fn.has "nvim-0.8" ~= 1 or vim.version().prerelease then
  vim.api.nvim_err_writeln(vim.tbl_concat({
    "Unsupported Neovim Version!",
    "Please ensure you have read the requirements carefully!",
  }, " "))
end

-- install profiling, if we have the right things available.
local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then impatient.enable_profile() end

require "options"
require "plugins"
require "autocmds"
require "commands"
