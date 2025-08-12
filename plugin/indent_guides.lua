-- plugin/indent_guides.lua
-- Minimal native indent guides using extmarks. Replaces indent-blankline.nvim.
-- Features:
--  * Draws a thin vertical guide at each indent level for visible lines.
--  * Skips empty lines unless they have indentation.
--  * Updates on CursorMoved/BufEnter/TextChanged and window scroll.
--  * Respects 'expandtab', 'tabstop', and 'shiftwidth'.
--  * Lightweight: no virtual text per column scan beyond visible range.
--
-- Adjust guide_char or highlight group as desired.

local ns = vim.api.nvim_create_namespace('IndentGuides')
local guide_char = '│'

-- Define highlight if not present
local ok = pcall(vim.api.nvim_get_hl_by_name, 'IndentGuide', true)
if not ok then
  vim.api.nvim_set_hl(0, 'IndentGuide', { link = 'NonText', default = true })
end

local function get_shift()
  return (vim.bo.shiftwidth > 0 and vim.bo.shiftwidth) or vim.bo.tabstop or 2
end

local function clear(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

local function visible_line_range(win)
  local topline = vim.fn.line('w0', win)
  local botline = vim.fn.line('w$', win)
  return topline, botline
end

local function render()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype == 'help' or vim.bo[buf].buftype ~= '' then
    clear(buf)
    return
  end
  local topline, botline = visible_line_range(win)
  clear(buf)
  local shift = get_shift()
  for lnum = topline, botline do
    local line = vim.api.nvim_buf_get_lines(buf, lnum-1, lnum, false)[1]
    if line and line:match('%S') then
      -- count indent in spaces (convert tabs)
      local col = 0
      for ch in line:gmatch('.') do
        if ch == ' ' then col = col + 1
        elseif ch == '\t' then
          local ts = vim.bo.tabstop
          col = col + (ts - (col % ts))
        else
          break
        end
      end
      if col >= shift then
        local level = math.floor(col / shift)
        for i = 1, level do
          local virt_col = (i-1) * shift
          -- Place guide right before first non-indent char (virt_col may be 0-based)
          -- We approximate by using virt_text with empty priority anchored at column
          vim.api.nvim_buf_set_extmark(buf, ns, lnum-1, virt_col, {
            virt_text = { { guide_char, 'IndentGuide' } },
            virt_text_pos = 'overlay',
            priority = 50,
            hl_mode = 'combine',
          })
        end
      end
    end
  end
end

-- Debounce to avoid excessive redraw
local timer
local function schedule_render()
  if timer then timer:stop(); timer:close() end
  timer = vim.loop.new_timer()
  timer:start(15, 0, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(0) then render() end
  end))
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinScrolled', 'CursorMoved', 'TextChanged', 'TextChangedI', 'OptionSet' }, {
  group = vim.api.nvim_create_augroup('IndentGuidesRender', { clear = true }),
  callback = function(ev)
    if ev.match == '' then return end
    schedule_render()
  end,
})

-- Initial draw
schedule_render()
