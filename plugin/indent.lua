-- plugin/indent.lua
-- Unified indentation utilities:
--  1. Heuristic indentation detection (shiftwidth/tabstop/expandtab inference)
--  2. Lightweight visual indent guides using extmarks
-- Replaces: vim-sleuth and indent-blankline.nvim
--
-- Sections:
--  A. Configuration knobs
--  B. Indent detection logic
--  C. Indent guide rendering logic
--  D. Autocommands & user commands
--
-- You can safely tweak the CONFIG table below to adjust behavior.

local api, fn = vim.api, vim.fn

--- Unified indentation detection + virtual guides configuration.
-- Adjust fields to tune heuristics and rendering behavior.
local CONFIG = {
  detect = {
    max_lines = 400, -- Maximum lines to scan per buffer
    min_samples = 4, -- Require at least this many indented lines before applying
    prefer = { 2, 4 }, -- Favored indentation deltas
    fallback = 4, -- Fallback shiftwidth if heuristic inconclusive
    comment_patterns = { -- Simple patterns treated as comment / ignorable lines
      "^%s*$", -- blank
      "^%s*[#/;%*!]+", -- generic comment starts
    },
  },
  guides = {
    enabled = true, -- Toggle guide rendering
    char = "│", -- Character used for each guide column
    debounce_ms = 15, -- Debounce for redraw events
    highlight = "IndentGuide", -- Highlight group (created if missing)
    max_indent_level = 120, -- Safety cap on number of guides per line
  },
}

------------------------------------------------------------------------
-- B. Indent Detection
------------------------------------------------------------------------
local Det = {}

local function is_comment_line(line)
  for _, pat in ipairs(CONFIG.detect.comment_patterns) do
    if line:match(pat) then return true end
  end
  return false
end

--- Heuristically detect indentation style for a buffer and apply options.
-- Considers space vs tab usage and common deltas; aborts on insufficient samples.
-- @param buf integer buffer handle
local function detect_indent(buf)
  if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "" then return end
  local line_count = api.nvim_buf_line_count(buf)
  local deltas = {}
  local space_indents, tab_indents, last_indent = 0, 0, nil
  local scanned = 0
  for i = 1, math.min(line_count, CONFIG.detect.max_lines) do
    local line = api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
    if line and not is_comment_line(line) then
      local ws = line:match "^(%s*)" or ""
      if ws ~= "" then
        if ws:find "\t" then tab_indents = tab_indents + 1 end
        if ws:find " " then space_indents = space_indents + 1 end
        local indent_len = 0
        for ch in ws:gmatch "." do
          if ch == " " then
            indent_len = indent_len + 1
          elseif ch == "\t" then
            local ts = vim.bo[buf].tabstop
            indent_len = indent_len + (ts - (indent_len % ts))
          end
        end
        if indent_len > 0 then
          if last_indent then
            local delta = math.abs(indent_len - last_indent)
            if delta > 0 and delta <= 8 then deltas[delta] = (deltas[delta] or 0) + 1 end
          end
          last_indent = indent_len
          scanned = scanned + 1
        end
      end
    end
  end
  if scanned < CONFIG.detect.min_samples then return end
  -- choose best delta
  local chosen, best_weight = nil, 0
  for k, count in pairs(deltas) do
    local weight = count
    for _, pref in ipairs(CONFIG.detect.prefer) do
      if k == pref then weight = weight + 1 end
    end
    if weight > best_weight then
      best_weight = weight
      chosen = k
    end
  end
  if not chosen then chosen = CONFIG.detect.fallback end
  local expand = true
  if tab_indents > 0 and tab_indents >= space_indents * 2 then expand = false end
  vim.bo[buf].shiftwidth = chosen
  vim.bo[buf].tabstop = chosen
  vim.bo[buf].softtabstop = chosen
  vim.bo[buf].expandtab = expand
  vim.b.indent_set = true
end

--- Run indent detection on the current buffer.
function Det.run() detect_indent(0) end

------------------------------------------------------------------------
-- C. Indent Guides
------------------------------------------------------------------------
local Guides = {}
local ns = api.nvim_create_namespace "IndentGuides"
local timer

local function ensure_hl()
  local ok = pcall(vim.api.nvim_get_hl_by_name, CONFIG.guides.highlight, true)
  if not ok then api.nvim_set_hl(0, CONFIG.guides.highlight, { link = "NonText", default = true }) end
end

local function current_shift() return (vim.bo.shiftwidth > 0 and vim.bo.shiftwidth) or vim.bo.tabstop or 2 end

local function clear(buf) api.nvim_buf_clear_namespace(buf, ns, 0, -1) end

local function visible_range(win) return fn.line("w0", win), fn.line("w$", win) end

local function measure_indent(line)
  local col = 0
  for ch in line:gmatch "." do
    if ch == " " then
      col = col + 1
    elseif ch == "\t" then
      local ts = vim.bo.tabstop
      col = col + (ts - (col % ts))
    else
      break
    end
  end
  return col
end

--- Render indent guides for the visible window range.
-- Skips special buffers; uses extmarks with virtual text.
local function render()
  if not CONFIG.guides.enabled then return end
  local win = api.nvim_get_current_win()
  local buf = api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "help" then
    clear(buf)
    return
  end
  local top, bottom = visible_range(win)
  clear(buf)
  local shift = current_shift()
  for lnum = top, bottom do
    local line = api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
    if line and line:match "%S" then
      local indent_cols = measure_indent(line)
      if indent_cols >= shift then
        local levels = math.min(math.floor(indent_cols / shift), CONFIG.guides.max_indent_level)
        for i = 1, levels do
          local virt_col = (i - 1) * shift
          api.nvim_buf_set_extmark(buf, ns, lnum - 1, virt_col, {
            virt_text = { { CONFIG.guides.char, CONFIG.guides.highlight } },
            virt_text_pos = "overlay",
            priority = 50,
            hl_mode = "combine",
          })
        end
      end
    end
  end
end

local function schedule()
  if timer then
    timer:stop()
    timer:close()
  end
  timer = vim.loop.new_timer()
  timer:start(
    CONFIG.guides.debounce_ms,
    0,
    vim.schedule_wrap(function()
      if api.nvim_buf_is_valid(0) then render() end
    end)
  )
end

--- Request a (debounced) refresh of indent guides.
function Guides.refresh() schedule() end
--- Toggle guide visibility globally (affects subsequent renders).
function Guides.toggle()
  CONFIG.guides.enabled = not CONFIG.guides.enabled
  if CONFIG.guides.enabled then
    schedule()
  else
    clear(0)
  end
  vim.notify("Indent guides: " .. (CONFIG.guides.enabled and "on" or "off"))
end

------------------------------------------------------------------------
-- D. Commands & Autocmds
------------------------------------------------------------------------
ensure_hl()

api.nvim_create_user_command("IndentDetect", function()
  Det.run()
  vim.notify(string.format("IndentDetect: shift=%d expand=%s", vim.bo.shiftwidth, tostring(vim.bo.expandtab)))
  schedule()
end, {})

api.nvim_create_user_command("IndentGuidesToggle", function() Guides.toggle() end, {})

api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
  group = api.nvim_create_augroup("IndentUnifiedDetect", { clear = true }),
  callback = function(args)
    if not vim.b.indent_set then detect_indent(args.buf) end
    schedule()
  end,
})

api.nvim_create_autocmd({ "WinScrolled", "CursorMoved", "TextChanged", "TextChangedI", "OptionSet" }, {
  group = api.nvim_create_augroup("IndentUnifiedRender", { clear = true }),
  callback = function() schedule() end,
})

-- Initial pass
Det.run()
schedule()

return { config = CONFIG, detect = Det, guides = Guides }
