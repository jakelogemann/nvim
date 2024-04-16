local M = {}

M.check = function()
  vim.health.report_start "my neovim health report"
  -- make sure setup function parameters are ok
  if true then
    vim.health.report_ok "Setup is correct"
  else
    vim.health.report_error "Setup is incorrect"
  end
  -- do some more checking
  -- ...
end

return M
