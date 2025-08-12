-- plugin/git_signs.lua
-- Minimal visual git diff signs (replacement for gitsigns when only display is needed).
-- Features:
--   * Shows added (+), changed (~), deleted (-) lines vs HEAD.
--   * Debounced refresh on edits, writes, focus, and buffer enter.
--   * Detects untracked files (marks all nonblank lines as added).
--   * Toggle command :GitSignsToggle
--   * Clean, no staging/reset, no blame, no hunk navigation.
--
-- Implementation notes:
--   * Uses `git diff -U0 --no-color --no-ext-diff HEAD -- <file>` to get zero-context hunks.
--   * Parses @@ headers and per-line +/- metadata to classify hunks.
--   * Deletions have no corresponding new file lines; we place a sign on the following line
--     (or last line of file if deletion at end).
--   * Changed hunks (both additions and deletions) mark added lines as changed (~).
--   * Pure addition hunks mark added lines as add (+).
--   * Pure deletion hunks mark one line with delete (-).
--   * If file untracked: mark every nonblank line add (+).
--
-- Limitations:
--   * Ignores renames, staged vs unstaged separation, and partial index state.
--   * Assumes relatively small files; for huge files (>100k lines) it bails early.
--   * Does not update while in special buffers / non-file buffers.
--
local api, fn = vim.api, vim.fn
local M = {}
local enabled = true
local ns = api.nvim_create_namespace "MiniGitSigns"
local timer
local debounce_ms = 120
local max_lines_threshold = 100000

-- Define sign types once
local defined = false
--- Define sign types once (idempotent).
local function define_signs()
  if defined then return end
  fn.sign_define("MiniGitSignAdd", { text = "+", texthl = "DiffAdd", numhl = "" })
  fn.sign_define("MiniGitSignChange", { text = "~", texthl = "DiffChange", numhl = "" })
  fn.sign_define("MiniGitSignDelete", { text = "-", texthl = "DiffDelete", numhl = "" })
  defined = true
end

--- Check whether buffer path is inside a git working tree.
-- @param buf integer buffer handle
-- @return boolean
local function in_git_repo(buf)
  local dir = fn.fnamemodify(api.nvim_buf_get_name(buf), ":p:h")
  if dir == "" then return false end
  local cmd = { "git", "-C", dir, "rev-parse", "--is-inside-work-tree" }
  local out = fn.systemlist(cmd)
  return out[1] == "true"
end

--- Determine if path is untracked (missing from index).
-- @param path string relative path
-- @return boolean
local function is_untracked(path)
  local out = fn.systemlist { "git", "ls-files", "--error-unmatch", path }
  return #out == 0 -- error-unmatch returns error; systemlist captures empty + sets v:shell_error
end

--- Clear all signs & extmarks for a buffer.
-- @param buf integer
local function clear(buf)
  fn.sign_unplace("MiniGitSigns", { buffer = buf })
  api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

--- Place a diff sign (protected call ignores duplicate issues).
-- @param buf integer
-- @param sign string defined sign name
-- @param lnum integer line number (1-indexed)
local function place(buf, sign, lnum) pcall(fn.sign_place, 0, "MiniGitSigns", sign, buf, { lnum = lnum, priority = 6 }) end

--- Parse zero-context git diff output into simplified hunk meta.
-- @param output string[] raw lines from `git diff -U0`
-- @return table[] hunks with counts
local function parse_diff(output)
  -- Returns list of hunks: { added_lines = {lnum,...}, deleted_spot = lnum_or_nil, changed = bool }
  local hunks = {}
  local current
  for _, line in ipairs(output) do
    if line:match "^@@" then
      local old_start, old_count, new_start, new_count = line:match "@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@"
      old_start, new_start = tonumber(old_start), tonumber(new_start)
      old_count = tonumber(old_count) or 1
      new_count = tonumber(new_count) or 1
      current = {
        old_start = old_start,
        old_count = old_count,
        new_start = new_start,
        new_count = new_count,
        added = {},
        removed = 0,
      }
      table.insert(hunks, current)
    elseif current then
      local prefix = line:sub(1, 1)
      if prefix == "+" and not line:match "^%+%+%+" then
        table.insert(current.added, true) -- placeholder; line number computed later
      elseif prefix == "-" and not line:match "^%-%-%-" then
        current.removed = current.removed + 1
      end
    end
  end
  return hunks
end

--- Convert parsed hunks to placed signs.
-- @param buf integer
-- @param hunks table[] from parse_diff
local function apply_signs(buf, hunks)
  for _, h in ipairs(hunks) do
    local added_cnt = #h.added
    local removed_cnt = h.removed
    if added_cnt == 0 and removed_cnt > 0 then
      -- pure deletion: mark deletion spot at h.new_start (line after deleted block) or last line
      local target = h.new_start
      local line_count = api.nvim_buf_line_count(buf)
      if target > line_count then target = line_count end
      if target < 1 then target = 1 end
      place(buf, "MiniGitSignDelete", target)
    elseif added_cnt > 0 and removed_cnt == 0 then
      -- pure addition: mark each added line
      for i = 0, added_cnt - 1 do
        place(buf, "MiniGitSignAdd", h.new_start + i)
      end
    elseif added_cnt > 0 and removed_cnt > 0 then
      -- modification: mark added lines as change
      for i = 0, added_cnt - 1 do
        place(buf, "MiniGitSignChange", h.new_start + i)
      end
    end
  end
end

--- Recompute & re-render signs for current buffer (debounced externally).
local function refresh()
  if not enabled then return end
  local buf = api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" or vim.bo[buf].modifiable == false then return end
  local path = api.nvim_buf_get_name(buf)
  if path == "" then return end
  if not in_git_repo(buf) then
    clear(buf)
    return
  end
  local rel = fn.fnamemodify(path, ":.")
  -- Bail on huge files
  if api.nvim_buf_line_count(buf) > max_lines_threshold then return end
  clear(buf)
  define_signs()
  if is_untracked(rel) then
    -- mark all nonblank lines as added
    local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
    for idx, l in ipairs(lines) do
      if l:match "%S" then place(buf, "MiniGitSignAdd", idx) end
    end
    return
  end
  local diff_cmd = { "git", "--no-pager", "diff", "--no-color", "--no-ext-diff", "-U0", "HEAD", "--", rel }
  local output = fn.systemlist(diff_cmd)
  if vim.v.shell_error ~= 0 then return end
  local hunks = parse_diff(output)
  apply_signs(buf, hunks)
end

--- Debounce wrapper scheduling a refresh on a libuv timer.
local function schedule_refresh()
  if timer then
    timer:stop()
    timer:close()
  end
  timer = vim.loop.new_timer()
  timer:start(
    debounce_ms,
    0,
    vim.schedule_wrap(function()
      if api.nvim_buf_is_valid(0) then refresh() end
    end)
  )
end

-- Public toggle
--- Toggle git sign rendering on/off for the current buffer.
function M.toggle()
  enabled = not enabled
  if not enabled then
    clear(0)
  else
    schedule_refresh()
  end
  vim.notify("Git signs: " .. (enabled and "on" or "off"))
end

api.nvim_create_user_command("GitSignsToggle", M.toggle, {})

api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI", "FocusGained" }, {
  group = api.nvim_create_augroup("MiniGitSignsRefresh", { clear = true }),
  callback = function() schedule_refresh() end,
})

-- Initial
schedule_refresh()

return M
