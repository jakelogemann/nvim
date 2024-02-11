local toggler = {}

toggler.number = function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = false
end

toggler.relativenumber = function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.wo.number = true
end

toggler.wrap = function() vim.wo.wrap = not vim.wo.wrap end

toggler.spell = function() vim.wo.spell = not vim.wo.spell end

toggler.cursorline = function() vim.opt.cursorline = not vim.opt.cursorline end

toggler.list = function() vim.wo.list = not vim.wo.list end

local user_command = function(args)
  local cmd = vim.trim(args.args or "")
  if toggler[cmd] then
    toggler[cmd]()
  else
    return
  end
end

local togglers = vim.tbl_keys(toggler)
table.sort(togglers)

vim.api.nvim_create_user_command("Toggle", user_command, {
  nargs = 1, --"?",
  desc = "Toggle anything!",
  complete = function(_, line)
    local matches = vim.tbl_filter(function(key) return key:find(line:match "^%s*%w+ (%w*)" or "") == 1 end, togglers)
    return matches
  end,
})

return toggler
