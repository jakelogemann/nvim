--- Lightweight commenting utility.
--
-- This module avoids external dependencies and works off the current buffer's
-- 'commentstring' when possible, falling back to language heuristics.
-- All public entry points are on the returned table `M`.
--
-- Public API:
-- * M.setup()            : define keymaps (<leader>c, visual <leader>c, gc operator)
-- * M.toggle_line()      : toggle comment state of current line
-- * M.toggle_selection() : toggle comment state of visual selection
-- * M.operator()         : operatorfunc implementation used by the gc mapping
--
-- Implementation notes:
-- * Idempotent toggling: if ALL nonblank lines in a range are commented, they
--   are all uncommented; else they are all commented.
-- * Keeps indentation and tries to avoid trailing whitespace churn.
local M = {}

--- Derive leading and trailing comment markers from 'commentstring'.
-- Falls back to shell / lua style when not set.
-- @return string pre  Leading comment sequence (no trailing space)
-- @return string post Trailing comment sequence ('' if none)
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

--- Determine if a given line is already commented with provided markers.
-- @param line string line text
-- @param pre string leading marker
-- @param post string trailing marker ('' if none)
-- @return boolean commented true when the line is considered commented
local function is_commented(line, pre, post)
  if post == '' then
    return vim.startswith(line, pre .. ' ') or (vim.startswith(line, pre) and (#line == #pre or line:sub(#pre+1,#pre+1):match('%s')))
  else
    return vim.startswith(line, pre) and line:sub(-#post) == post
  end
end

--- Toggle a contiguous block of lines between commented / uncommented.
-- Lines containing only whitespace are ignored (left untouched).
-- @param start_l integer 1-indexed first line
-- @param end_l integer 1-indexed last line (inclusive)
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

--- Toggle comment state of the current cursor line.
function M.toggle_line()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  comment_lines(l, l)
end

--- Toggle comment state for the visually selected range (v/V).
-- Uses marks '< and '>. Automatically normalizes reversed selections.
function M.toggle_selection()
  local start_l = vim.fn.getpos('v')[2]
  local end_l = vim.fn.getpos('.') [2]
  if start_l > end_l then start_l, end_l = end_l, start_l end
  comment_lines(start_l, end_l)
end

--- Operatorfunc entry point (used by mapping that sets operatorfunc).
-- Relies on '[' and ']' marks populated by the operator pending motion.
function M.operator()
  local start_l = vim.fn.getpos('[')[2]
  local end_l = vim.fn.getpos(']')[2]
  comment_lines(start_l, end_l)
end

--- Convenience wrapper around vim.keymap.set adding default opts.
-- @param mode string|table mode(s)
-- @param lhs string lhs
-- @param rhs string|function rhs
-- @param desc string description (for which-key / :map listing)
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc or 'comment', silent = true })
end

--- Define default keymaps for comment toggling.
-- Safe to call multiple times (maps are idempotent with same options).
function M.setup()
  map('n', '<leader>c', M.toggle_line, 'Toggle comment (line)')
  map('v', '<leader>c', M.toggle_selection, 'Toggle comment (visual)')
  map('n', 'gc', function()
    vim.o.operatorfunc = 'v:lua.require"custom.comment".operator'
    return 'g@'
  end, 'Comment operator')
end

return M
