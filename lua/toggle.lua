local toggle = {
  number = function()
    vim.wo.number = not vim.wo.number
    vim.wo.relativenumber = false
  end,
  relativenumber = function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    vim.wo.number = true
  end,
  wrap = function() vim.wo.wrap = not vim.wo.wrap end,
  spell = function() vim.wo.spell = not vim.wo.spell end,
  cursorline = function() vim.opt.cursorline = not vim.opt.cursorline end,
  list = function() vim.wo.list = not vim.wo.list end,
}

vim.api.nvim_create_user_command("Toggle", function(args)
  local cmd = vim.trim(args.args or "")
  if cmd == "" then
    return
  elseif toggle[cmd] then
    toggle[cmd]()
  else
    -- should handle errors
    return
  end
end, {
  nargs = 1, --"?",
  desc = "Toggle anything!",
  complete = function(_, line)
    if line:match "^%s*Toggle %w+ " then return {} end
    return vim.tbl_filter(
      function(key) return key:find(line:match "^%s*Toggle (%w*)" or "") == 1 end,
      vim.tbl_keys(toggle)
    )
  end,
})

return toggle
