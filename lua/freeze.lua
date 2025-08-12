--- Minimal wrapper around the external `freeze` CLI to capture code snippets as images.
-- Provides :Freeze and :FreezeLine commands and an `open` helper for macOS.
-- @module freeze
local stdio = { stdout = "", stderr = "" }
local default_output = "freeze.png"

-- Determine the user's download folder in a cross-platform way
--- Determine a downloads directory path (cross-platform best effort).
-- @return string|nil absolute path or nil when not resolvable
local function get_download_folder()
  -- Unix-like systems (Linux/Mac)
  local xdg_dir = os.getenv "XDG_DOWNLOAD_DIR"
  if xdg_dir and xdg_dir ~= "" then return xdg_dir end

  -- Windows
  local userprofile = os.getenv "USERPROFILE"
  if userprofile then return userprofile .. "\\Downloads" end

  -- Fallback to ~/Downloads on Unix-like systems
  local home = os.getenv "HOME"
  if home then return home .. "/Downloads" end

  -- Fallback to nil if no reasonable default
  return nil
end

--- Module table.
-- @class FreezeModule
-- @field opts table runtime options (dir, output template, config, open)
-- @field output string|nil last generated image path
local freeze = {
  opts = {
    ---@type string|nil output directory (default: detected downloads folder)
    dir = get_download_folder(),
    ---@type string output filename or template (supports placeholders: {timestamp},{filename},{start_line},{end_line})
    output = default_output,
    ---@type string name of freeze config profile to pass as --config
    config = "base",
    ---@type boolean open resulting image automatically (macOS only via `open`)
    open = false,
  },
  output = nil,
}

---The callback for reading stdout.
---@param err any the possible err we received
---@param data any the possible data we received in stdout
--- Collect stdout chunks and optionally auto-open on completion.
-- @param err any error object (if any)
-- @param data string|nil partial data
local function onReadStdOut(err, data)
  if err then vim.notify(err, vim.log.levels.ERROR, { title = "Freeze" }) end
  if data then stdio.stdout = stdio.stdout .. data end
  if freeze.opts.open and freeze.output ~= nil then
    freeze.open(freeze.output)
    freeze.output = nil
  end
end

---The callback for reading stderr.
---@param err any the possible err we received
---@param data any the possible data we received in stderr
--- Collect stderr chunks.
-- @param err any error object
-- @param data string|nil partial data
local function onReadStdErr(err, data)
  if err then vim.notify(err, vim.log.levels.ERROR, { title = "Freeze" }) end
  if data then stdio.stderr = stdio.stderr .. data end
end

---The function called on exit of from the event loop
---@param stdout any the stdout pipe used by vim.loop
---@param stderr any the stderr pipe used by vim.loop
---@return function cb the wrapped schedule function callback
--- Create an on-exit handler to finalize resources & notify user.
-- @param stdout uv_pipe_t stdout pipe
-- @param stderr uv_pipe_t stderr pipe
-- @return function callback scheduled on exit
local function onExit(stdout, stderr)
  return vim.schedule_wrap(function(code, _)
    if code == 0 then
      vim.notify("Successfully frozen 🍦", vim.log.levels.INFO, { title = "Freeze" })
    else
      vim.notify(stdio.stdout, vim.log.levels.ERROR, { title = "Freeze" })
    end
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
  end)
end

--- The main function used for passing the main config to lua
---
--- This function will take your lines and the found Vim filetype and pass it
--- to `freeze --language <vim filetype> --lines <start_line>,<end_line> <file>`
--- @param start_line number the starting line to pass to freeze
--- @param end_line number the ending line to pass to freeze
--- Generate an image for the current buffer between two (inclusive) line numbers.
-- Resolves output filename template and spawns the `freeze` CLI.
-- @param start_line integer starting line (1-indexed)
-- @param end_line integer ending line (1-indexed)
function freeze.freeze(start_line, end_line)
  if vim.fn.executable "freeze" ~= 1 then
    vim.notify("`freeze` not found!", vim.log.levels.WARN, { title = "Freeze" })
    return
  end

  local language = vim.api.nvim_buf_get_option(0, "filetype")
  local file = vim.api.nvim_buf_get_name(0)
  local config = freeze.opts.config
  local dir = freeze.opts.dir
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local output = freeze.opts.output

  if freeze.opts.output ~= default_output then
    local timestamp = os.date "%Y%m%d%H%M%S"
    local filename = file:match "^.+/(.+)$" or file

    output = output:gsub("{timestamp}", timestamp)
    output = output:gsub("{filename}", filename)
    output = output:gsub("{start_line}", start_line)
    output = output:gsub("{end_line}", end_line)
  end

  freeze.output = dir .. "/" .. output

  local handle = vim.loop.spawn("freeze", {
    args = {
      "--output",
      freeze.output,
      "--language",
      language,
      "--lines",
      start_line .. "," .. end_line,
      "--config",
      config,
      file,
    },
    stdio = { nil, stdout, stderr },
  }, onExit(stdout, stderr))
  if not handle then vim.notify("Failed to spawn freeze", vim.log.levels.ERROR, { title = "Freeze" }) end
  if stdout ~= nil then vim.loop.read_start(stdout, onReadStdOut) end
  if stderr ~= nil then vim.loop.read_start(stderr, onReadStdErr) end
end

--- Opens the last created image in macOS using `open`.
--- @param filename string the filename to open
--- Open an image file using the macOS `open` command.
-- No-ops (warn) if `open` isn't available.
-- @param filename string absolute path to image
function freeze.open(filename)
  if vim.fn.executable "open" ~= 1 then
    vim.notify("`open` not found!", vim.log.levels.WARN, { title = "Freeze" })
    return
  end

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle = vim.loop.spawn("open", {
    args = {
      filename,
    },
    stdio = { nil, stdout, stderr },
  }, onExit(stdout, stderr))
  if not handle then vim.notify("Failed to spawn freeze", vim.log.levels.ERROR, { title = "Freeze" }) end
  if stdout ~= nil then vim.loop.read_start(stdout, onReadStdOut) end
  if stderr ~= nil then vim.loop.read_start(stderr, onReadStdErr) end
end

--- Setup function for enabling both user commands.
--- Sets up :Freeze for freezing a selection and :FreezeLine
--- to freeze a single line.
--- Setup user commands (:Freeze, :FreezeLine) and merge custom options.
-- @param plugin_opts table|nil overrides for opts
function freeze.setup(plugin_opts)
  if plugin_opts then
    for k, v in pairs(plugin_opts) do
      freeze.opts[k] = v
    end
  end
  vim.api.nvim_create_user_command("Freeze", function(opts)
    if opts.count > 0 then
      freeze.freeze(opts.line1, opts.line2)
    else
      freeze.freeze(1, vim.api.nvim_buf_line_count(0))
    end
  end, { range = true })
  vim.api.nvim_create_user_command("FreezeLine", function(_)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    freeze.freeze(line, line)
  end, {})
end

return freeze
