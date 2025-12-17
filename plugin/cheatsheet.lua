-- plugin/cheatsheet.lua
-- Show the Keymap Quick Reference section from README.md in a floating window.

local M = {}
local state = { win = nil, buf = nil }

local function read_quickref()
  local root = vim.fn.stdpath "config"
  local path = root .. "/README.md"
  if vim.fn.filereadable(path) ~= 1 then return { "Keymap Quick Reference not found" } end
  local lines = vim.fn.readfile(path)
  local start_idx, end_idx
  for i, l in ipairs(lines) do
    if l:match "^## Keymap Quick Reference" then
      start_idx = i
      break
    end
  end
  if not start_idx then return { "Keymap Quick Reference section missing" } end
  for i = start_idx + 1, #lines do
    if lines[i]:match "^## " then
      end_idx = i - 1
      break
    end
  end
  end_idx = end_idx or #lines
  local out = {}
  for i = start_idx, end_idx do
    table.insert(out, lines[i])
  end
  return #out > 0 and out or { "Keymap Quick Reference section is empty" }
end

local function open_float()
  local content = read_quickref()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    return
  end
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(state.buf, "filetype", "markdown")
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(state.buf, "modifiable", false)

  local columns = vim.o.columns
  local lines = vim.o.lines
  local width = math.max(60, math.floor(columns * 0.6))
  local height = math.max(20, math.floor(lines * 0.6))
  local row = math.floor((lines - height) / 2) - 1
  local col = math.floor((columns - width) / 2)

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Keymap Quick Reference ",
    title_pos = "center",
  })
  vim.keymap.set("n", "q", function()
    if state.win and vim.api.nvim_win_is_valid(state.win) then vim.api.nvim_win_close(state.win, true) end
  end, { buffer = state.buf, nowait = true, silent = true })
end

vim.api.nvim_create_user_command("Cheatsheet", function() open_float() end, { desc = "Show keymap quick reference" })

return M

