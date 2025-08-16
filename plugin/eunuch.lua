-- plugin/eunuch.lua
-- Minimal native replacements for a subset of tpope/vim-eunuch commands.
-- Focus on common operations: Delete, Remove, Move, Chmod, Mkdir, SudoWrite, SudoEdit, Wall.
-- Each implemented as a user command leveraging built-in Lua / shell.
-- NOTE: For safety, destructive actions prompt for confirmation unless '!' bang is used.

local api = vim.api
local fn = vim.fn
local M = {}

--- Show a namespaced notification for eunuch-lite commands.
-- @param msg string
-- @param level integer|nil vim.log.levels.*
local function notify(msg, level) vim.notify(msg, level or vim.log.levels.INFO, { title = "eunuch-lite" }) end

--- Prompt user to confirm a destructive action.
-- @param prompt string message
-- @return boolean confirmed
local function confirm(prompt) return 1 == fn.confirm(prompt .. " (y to confirm)", "&y\n&n", 2) end

-- Helper to resolve current file path (absolute)
--- Resolve absolute path of current buffer (nil if unnamed).
-- @return string|nil path
local function current_path()
  local name = api.nvim_buf_get_name(0)
  if name == "" then return nil end
  return fn.fnamemodify(name, ":p")
end

-- :Delete[!]  Delete current file from disk and wipe buffer
api.nvim_create_user_command("Delete", function(opts)
  local path = current_path()
  if not path then return notify("No file name", vim.log.levels.WARN) end
  if not fn.filereadable(path) and fn.isdirectory(path) == 0 then return notify("File does not exist: " .. path, vim.log.levels.WARN) end
  if not opts.bang and not confirm("Delete " .. path .. "?") then return end
  local ok, err = os.remove(path)
  if not ok then return notify("Delete failed: " .. tostring(err), vim.log.levels.ERROR) end
  notify("Deleted " .. path)
  vim.cmd "bdelete!"
end, { bang = true })

-- :Remove[!]  Like Delete but does not close buffer (marks it as [No Name])
api.nvim_create_user_command("Remove", function(opts)
  local path = current_path()
  if not path then return notify("No file name", vim.log.levels.WARN) end
  if not fn.filereadable(path) then return notify("File does not exist: " .. path, vim.log.levels.WARN) end
  if not opts.bang and not confirm("Remove " .. path .. "?") then return end
  local ok, err = os.remove(path)
  if not ok then return notify("Remove failed: " .. tostring(err), vim.log.levels.ERROR) end
  notify("Removed " .. path)
  vim.bo.modified = false
  api.nvim_buf_set_name(0, "")
end, { bang = true })

-- :Move {newpath}  Rename file and buffer
api.nvim_create_user_command("Move", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Move {newpath}", vim.log.levels.WARN) end
  local old = current_path()
  if not old then return notify("No file name", vim.log.levels.WARN) end
  local new = fn.fnamemodify(opts.fargs[1], ":p")
  local ok, err = os.rename(old, new)
  if not ok then return notify("Move failed: " .. tostring(err), vim.log.levels.ERROR) end
  api.nvim_buf_set_name(0, new)
  notify(string.format("Moved %s -> %s", old, new))
end, { nargs = 1, complete = "file" })

-- :Rename {newpath} (alias for :Move)
api.nvim_create_user_command(
  "Rename",
  function(opts) vim.cmd("Move " .. table.concat(opts.fargs, " ")) end,
  { nargs = 1, complete = "file" }
)

-- :Chmod {mode}  Change permissions of current file
api.nvim_create_user_command("Chmod", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Chmod {mode}", vim.log.levels.WARN) end
  local path = current_path()
  if not path then return notify("No file name", vim.log.levels.WARN) end
  local mode = opts.fargs[1]
  local ok = os.execute(string.format("chmod %q %q", mode, path))
  if ok then
    notify("chmod " .. mode .. " " .. path)
  else
    notify("chmod failed", vim.log.levels.ERROR)
  end
end, { nargs = 1 })

-- :Mkdir[!] [path] Create directory (default: parent of current file)
api.nvim_create_user_command("Mkdir", function(opts)
  local path = opts.fargs[1]
  if not path or path == "" then
    local cur = current_path()
    if not cur then return notify("Usage: :Mkdir {path}", vim.log.levels.WARN) end
    path = fn.fnamemodify(cur, ":p:h")
  end
  path = fn.fnamemodify(path, ":p")
  if fn.isdirectory(path) == 1 then return notify("Directory exists: " .. path) end
  local ok = fn.mkdir(path, "p")
  if ok == 1 then
    notify("Created directory " .. path)
  else
    notify("Failed to create directory", vim.log.levels.ERROR)
  end
end, { nargs = "?", bang = true, complete = "dir" })

-- :SudoWrite write current buffer with sudo (on Unix)
api.nvim_create_user_command("SudoWrite", function()
  local path = current_path() or fn.expand "%:p"
  if path == "" then return notify("No file name", vim.log.levels.WARN) end
  if fn.has "unix" == 0 then return notify("SudoWrite only supported on unix", vim.log.levels.WARN) end
  -- Write to a temp file first
  local tmp = fn.tempname()
  vim.cmd("write! " .. tmp)
  local cmd = string.format("sudo tee %q > /dev/null < %q", path, tmp)
  local rc = os.execute(cmd)
  if rc then
    notify("Wrote (sudo) " .. path)
    vim.cmd "edit!"
  else
    notify("SudoWrite failed", vim.log.levels.ERROR)
  end
end, {})

-- :SudoEdit reopen file with sudo rights
api.nvim_create_user_command("SudoEdit", function()
  local path = current_path()
  if not path then return notify("No file name", vim.log.levels.WARN) end
  if fn.has "unix" == 0 then return notify("SudoEdit only supported on unix", vim.log.levels.WARN) end
  vim.cmd("edit " .. path)
  notify("Re-opened " .. path .. " (use :SudoWrite to write)")
end, {})

-- :Wall write all visible buffers
api.nvim_create_user_command("Wall", function()
  vim.cmd "wall"
  notify "All written"
end, {})

-- Simple :Cfind wrapper using system find (very naive; user should customize)
api.nvim_create_user_command("Cfind", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Cfind {pattern}", vim.log.levels.WARN) end
  local pattern = opts.fargs[1]
  local cmd = string.format("find . -type f -name %q", pattern)
  local handle = io.popen(cmd)
  if not handle then return notify("find failed", vim.log.levels.ERROR) end
  local results = {}
  for line in handle:lines() do
    table.insert(results, line)
  end
  handle:close()
  if #results == 0 then return notify "No matches" end
  fn.setqflist({}, " ", {
    title = "Cfind " .. pattern,
    items = vim.tbl_map(function(f) return { filename = f, lnum = 1, col = 1, text = f } end, results),
  })
  notify("Loaded " .. #results .. " files into quickfix")
  vim.cmd "copen"
end, { nargs = 1 })

-- :Lfind {pattern} -> location list version of Cfind
api.nvim_create_user_command("Lfind", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Lfind {pattern}", vim.log.levels.WARN) end
  local pattern = opts.fargs[1]
  local cmd = string.format("find . -type f -name %q", pattern)
  local handle = io.popen(cmd)
  if not handle then return notify("find failed", vim.log.levels.ERROR) end
  local results = {}
  for line in handle:lines() do
    table.insert(results, line)
  end
  handle:close()
  if #results == 0 then return notify "No matches" end
  fn.setloclist(0, {}, " ") -- clear
  fn.setloclist(0, {}, " ", {
    title = "Lfind " .. pattern,
    items = vim.tbl_map(function(f) return { filename = f, lnum = 1, col = 1, text = f } end, results),
  })
  notify("Loaded " .. #results .. " files into location list")
  vim.cmd "lopen"
end, { nargs = 1 })

local function run_locate(pattern)
  if fn.executable "locate" == 0 then
    notify("locate command not available", vim.log.levels.WARN)
    return {}
  end
  local handle = io.popen(string.format("locate %q", pattern))
  if not handle then
    notify("locate failed", vim.log.levels.ERROR)
    return {}
  end
  local results = {}
  for line in handle:lines() do
    -- Only include existing regular files to reduce noise
    if fn.filereadable(line) == 1 then table.insert(results, line) end
  end
  handle:close()
  return results
end

-- :Clocate {pattern} -> quickfix from locate
api.nvim_create_user_command("Clocate", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Clocate {pattern}", vim.log.levels.WARN) end
  local pattern = opts.fargs[1]
  local results = run_locate(pattern)
  if #results == 0 then return notify "No matches (locate)" end
  fn.setqflist({}, " ", {
    title = "Clocate " .. pattern,
    items = vim.tbl_map(function(f) return { filename = f, lnum = 1, col = 1, text = f } end, results),
  })
  notify("Loaded " .. #results .. " files into quickfix (locate)")
  vim.cmd "copen"
end, { nargs = 1 })

-- :Llocate {pattern} -> location list from locate
api.nvim_create_user_command("Llocate", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Llocate {pattern}", vim.log.levels.WARN) end
  local pattern = opts.fargs[1]
  local results = run_locate(pattern)
  if #results == 0 then return notify "No matches (locate)" end
  fn.setloclist(0, {}, " ") -- clear
  fn.setloclist(0, {}, " ", {
    title = "Llocate " .. pattern,
    items = vim.tbl_map(function(f) return { filename = f, lnum = 1, col = 1, text = f } end, results),
  })
  notify("Loaded " .. #results .. " files into location list (locate)")
  vim.cmd "lopen"
end, { nargs = 1 })

-- :Copy {newpath}  Write current file to new path and edit the copy
api.nvim_create_user_command("Copy", function(opts)
  if #opts.fargs == 0 then return notify("Usage: :Copy {newpath}", vim.log.levels.WARN) end
  local src = current_path()
  if not src then return notify("No file name", vim.log.levels.WARN) end
  local dst = fn.fnamemodify(opts.fargs[1], ":p")
  if fn.filereadable(dst) == 1 and not opts.bang then
    if not confirm("Overwrite existing file " .. dst .. "?") then return end
  end
  -- Ensure current buffer written
  if vim.bo.modified then vim.cmd "write" end
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local ok, err = pcall(fn.writefile, lines, dst)
  if not ok then return notify("Copy failed: " .. tostring(err), vim.log.levels.ERROR) end
  notify(string.format("Copied %s -> %s", src, dst))
  vim.cmd("edit " .. dst)
end, { nargs = 1, bang = true, complete = "file" })

-- :Duplicate [newpath]
-- If newpath omitted, create sibling with -copy, -copy2, ... suffix.
-- Keeps editing the original buffer.
api.nvim_create_user_command("Duplicate", function(opts)
  local src = current_path()
  if not src then return notify("No file name", vim.log.levels.WARN) end
  local target = opts.fargs[1]
  if not target or target == "" then
    local dir = fn.fnamemodify(src, ":p:h")
    local base = fn.fnamemodify(src, ":t:r")
    local ext = fn.fnamemodify(src, ":e")
    local suffix = "-copy"
    local candidate
    local idx = 0
    while true do
      candidate = string.format("%s/%s%s%s", dir, base, idx == 0 and suffix or (suffix .. idx), ext ~= "" and ("." .. ext) or "")
      if fn.filereadable(candidate) == 0 then break end
      idx = idx + 1
    end
    target = candidate
  else
    target = fn.fnamemodify(target, ":p")
  end
  if fn.filereadable(target) == 1 and not opts.bang then
    if not confirm("Overwrite existing file " .. target .. "?") then return end
  end
  if vim.bo.modified then vim.cmd "write" end
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local ok, err = pcall(fn.writefile, lines, target)
  if not ok then return notify("Duplicate failed: " .. tostring(err), vim.log.levels.ERROR) end
  notify(string.format("Duplicated %s -> %s (stayed on original)", src, target))
end, { nargs = "?", bang = true, complete = "file" })

return M
