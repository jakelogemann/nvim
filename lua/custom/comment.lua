-- lua/custom/comment.lua
-- Lightweight commenting utility module
-- Provides functions: setup(), toggle_line(), toggle_selection(), operator()
-- Designed to be required by plugin/comment.lua and keymaps.
local M = {}

local function get_comment_parts()
  local cs = vim.bo.commentstring
  if not cs or cs == '' or not cs:find('%%s') then
    if vim.bo.filetype == 'lua' then return '--', '' end
    return '#', ''
  end
  local pre, post = cs:match('^(.*)%%s(.*)$')
  pre = pre:gsub('%s+$','')
  post = post:gsub('^%s+','')
  return pre, post
end

local function is_commented(line, pre, post)
  if post == '' then
    return vim.startswith(line, pre .. ' ') or (vim.startswith(line, pre) and (#line == #pre or line:sub(#pre+1,#pre+1):match('%s')))
  else
    return vim.startswith(line, pre) and line:sub(-#post) == post
  end
end

local function comment_lines(start_l, end_l)
  local pre, post = get_comment_parts()
  local lines = vim.api.nvim_buf_get_lines(0, start_l-1, end_l, false)
  local all_commented = true
  for _, line in ipairs(lines) do
    if line:match('%S') and not is_commented(line, pre, post) then
      all_commented = false
      break
    end
  end
  for i, line in ipairs(lines) do
    if line:match('%S') then
      if all_commented then
        if post ~= '' and line:sub(-#post) == post then
          line = line:sub(1, #line-#post)
        end
        if vim.startswith(line, pre .. ' ') then
          line = line:sub(#pre+2)
        elseif vim.startswith(line, pre) then
          line = line:sub(#pre+1)
          line = line:gsub('^%s','')
        end
      else
        if post == '' then
          line = pre .. ' ' .. line
        else
          line = pre .. ' ' .. line .. ' ' .. post
        end
      end
      lines[i] = line
    end
  end
  vim.api.nvim_buf_set_lines(0, start_l-1, end_l, false, lines)
end

function M.toggle_line()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  comment_lines(l, l)
end

function M.toggle_selection()
  local start_l = vim.fn.getpos('v')[2]
  local end_l = vim.fn.getpos('.') [2]
  if start_l > end_l then start_l, end_l = end_l, start_l end
  comment_lines(start_l, end_l)
end

function M.operator()
  local start_l = vim.fn.getpos('[')[2]
  local end_l = vim.fn.getpos(']')[2]
  comment_lines(start_l, end_l)
end

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc or 'comment', silent = true })
end

function M.setup()
  map('n', '<leader>c', M.toggle_line, 'Toggle comment (line)')
  map('v', '<leader>c', M.toggle_selection, 'Toggle comment (visual)')
  map('n', 'gc', function()
    vim.o.operatorfunc = 'v:lua.require"custom.comment".operator'
    return 'g@'
  end, 'Comment operator')
end

return M
