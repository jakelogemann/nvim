vim.api.nvim_create_user_command("ToggleLineNumbers", function()
  local ln = vim.opt.number:get()
  vim.wo.number = not ln
  vim.wo.relativenumber = ln
end, {
  desc = "toggle line numbers in the current buffer",
})
