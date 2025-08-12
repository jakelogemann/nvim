--- Utility helpers used across the config.
--
-- This module exposes a collection of small focused helpers for keymaps,
-- notifications, shell execution, string manipulation, option setting, and
-- lightweight UI toggles. Functions are intentionally minimal and synchronous
-- unless noted. All functions are safe to require multiple times.
-- @module custom.utils
local utils = { ui = {} }

--- Attempt to enable the 'impatient' profiling extension (if installed).
-- Silently no-ops when unavailable.
function utils.try_to_enable_profiler()
  -- use profiling, if available.
  local ok, profiler = pcall(require, "impatient")
  if ok then profiler.enable_profile() end
end

--- Map a normal mode key with a description (wrapper around vim.keymap.set).
-- @param keys string lhs keys
-- @param desc string description shown in which-key / :map
-- @param fn function|string rhs
function utils.nmap(keys, desc, fn) vim.keymap.set("n", keys, fn, { desc = desc }) end

-- Merge extended options with a default table of options
-- @param opts the new options that should be merged with the default table
-- @param default the default table that you want to merge into
-- @return the merged table
--- Merge a user options table into defaults (deep extend, force strategy).
-- @generic T
-- @param opts table|nil user provided overrides
-- @param default table|nil base table (may be nil)
-- @return table merged resulting table (never nil)
function utils.default_tbl(opts, default)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Call function if a condition is met
-- @param func the function to run
-- @param condition a boolean value of whether to run the function or not
--- Conditionally invoke a function and return its result.
-- @param func function function to call
-- @param condition boolean|nil when false the function is skipped
-- @param ... any forwarded arguments
-- @return any result of func(...) when executed, otherwise nil
function utils.conditional_func(func, condition, ...)
  -- if the condition is true or no condition is provided, evaluate the function with the rest of the parameters and return the result
  if (condition == nil or condition) and type(func) == "function" then return func(...) end
end

--- Trim a string or return nil
-- @param str the string to trim
-- @return a trimmed version of the string or nil if the parameter isn't a string
--- Trim a string or return nil if input not a string.
-- @param str any value that may be a string
-- @return string|nil trimmed string or nil when not a string
function utils.trim_or_nil(str) return type(str) == "string" and vim.trim(str) or nil end

--- Add left and/or right padding to a string
-- @param str the string to add padding to
-- @param padding a table of the format `{ left = 0, right = 0}` that defines the number of spaces to include to the left and the right of the string
-- @return the padded string
--- Add left/right padding spaces around a string.
-- Returns empty string when input is falsy or empty.
-- @param str string|nil base string
-- @param padding table|nil { left = int, right = int }
-- @return string padded string or ''
function utils.pad_string(str, padding)
  padding = padding or {}
  return str and str ~= "" and string.rep(" ", padding.left or 0) .. str .. string.rep(" ", padding.right or 0) or ""
end

--- Serve a notification with a title of AstroNvim
-- @param msg the notification body
-- @param type the type of the notification (:help vim.log.levels)
-- @param opts table of nvim-notify options to use (:help notify-options)
--- Show a namespaced notification (title="AstroNvim" by default).
-- @param msg string message body
-- @param type integer|nil vim.log.levels.* constant
-- @param opts table|nil nvim-notify options merged with {title="AstroNvim"}
function utils.notify(msg, type, opts)
  vim.schedule(function() vim.notify(msg, type, utils.default_tbl(opts, { title = "AstroNvim" })) end)
end

--- Trigger a User event
-- @param pattern the event name to be emitted
--- Emit a custom User autocommand asynchronously.
-- @param pattern string pattern passed to nvim_exec_autocmds
function utils.emit_event(pattern)
  vim.schedule(function() vim.api.nvim_exec_autocmds("User", { pattern = pattern }) end)
end

--- Wrapper function for neovim echo API
-- @param messages an array like table where each item is an array like table of strings to echo
--- Echo multiple highlighted message chunks.
-- @param messages table|nil array of {text, highlight?} tables; defaults to newline
function utils.echo(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
end

--- Echo a message and prompt the user for yes or no response
-- @param prompt the message to echo
-- @return True if the user responded y, False for any other response
--- Prompt the user for a y/n confirmation in the cmdline.
-- @param prompt string message to show (may be nil)
-- @return boolean true when user answers 'y'
function utils.confirm(prompt)
  if prompt then utils.echo(prompt) end
  local confirmed = string.lower(vim.fn.input "(y/n) ") == "y"
  utils.echo() -- clear the prompt & response.
  return confirmed
end

--- Set vim options with a nested table like API with the format vim.<first_key>.<second_key>.<value>
-- @param options the nested table of vim options
--- Apply nested vim option tables: vim[scope][setting] = value.
-- Scope keys typically: 'o', 'wo', 'bo', 'opt'.
-- @param options table nested scope->setting->value map
function utils.vim_opts(options)
  for scope, table in pairs(options) do
    for setting, value in pairs(table) do
      vim[scope][setting] = value
    end
  end
end

--- Run a shell command and capture the output and if the command succeeded or failed
-- @param cmd the terminal command to execute
-- @param show_error boolean of whether or not to show an unsuccessful command as an error to the user
-- @return the result of a successfully executed command or nil
--- Run a shell command and capture cleaned stdout on success.
-- Strips ANSI color codes. Shows error (stderr) unless suppressed.
-- @param cmd string|table command (string executed via shell unless on win32)
-- @param show_error boolean|nil set false to suppress error display
-- @return string|nil stdout result when successful, else nil
function utils.cmd(cmd, show_error)
  if vim.fn.has "win32" == 1 then cmd = { "cmd.exe", "/C", cmd } end
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar "shell_error" == 0
  if not success and (show_error == nil and true or show_error) then
    vim.api.nvim_err_writeln("Error running command: " .. cmd .. "\nError message:\n" .. result)
  end
  return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

--- Check if a buffer is valid
-- @param bufnr the buffer to check
-- @return true if the buffer is valid or false
--- Check whether a buffer is listed & valid.
-- @param bufnr integer buffer handle
-- @return boolean valid
function utils.is_valid_buffer(bufnr)
  if not bufnr or bufnr < 1 then return false end
  return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr)
end

--- Close the current tab
--- Close the current tabpage if more than one is open.
-- Cleans tab-local buffer list (vim.t.bufs) to avoid stale state.
function utils.close_tab()
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.t.bufs = nil
    vim.cmd.tabclose()
  end
end

--- Return string 'on'/'off' for a boolean value.
-- @param bool boolean
-- @return string
function utils.on_or_off(bool) return bool and "on" or "off" end

--- Toggle conceal=2|0
function utils.ui.toggle_conceal() vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0 end

-- Determine the user's download folder in a cross-platform way
--- Determine a plausible OS-specific downloads folder.
-- Checks XDG, then USERPROFILE, then HOME/Downloads.
-- @return string|nil absolute path or nil when undetermined
function utils.get_download_folder()
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

--- Run a command in an existing integrated terminal (ToggleTerm if available) or spawn a new one.
-- Tries, in order: existing ToggleTerm hidden terminal, new ToggleTerm, then built-in :terminal split.
-- @param cmd string shell command to execute
-- @param opts table|nil { direction = 'float'|'horizontal'|'vertical', cwd = string }
--- Execute a shell command in a (reused) integrated terminal.
-- Prefers toggleterm if available; falls back to a builtin split + :terminal.
-- Maintains a persistent hidden terminal for faster subsequent invocations.
-- @param cmd string command to run (required)
-- @param opts table|nil { direction = 'float'|'horizontal'|'vertical', cwd = string }
function utils.run_in_term(cmd, opts)
  opts = opts or {}
  if not cmd or cmd == "" then return end
  -- Prefer toggleterm if installed
  local ok_toggle, toggleterm = pcall(require, "toggleterm.terminal")
  if ok_toggle then
    local direction = opts.direction or "float"
    -- Reuse a persistent terminal keyed by direction
    local key = 9876 -- arbitrary id unlikely to collide
    local Terminal = toggleterm.Terminal
    if not utils._terminals then utils._terminals = {} end
    if not utils._terminals[key] or utils._terminals[key].closed then
      utils._terminals[key] = Terminal:new {
        id = key,
        direction = direction,
        hidden = true,
        cmd = nil,
        dir = opts.cwd,
        close_on_exit = false,
        on_open = function(term)
          -- ensure insert mode for immediate output readability
          vim.api.nvim_buf_set_option(term.bufnr, "filetype", "term")
        end,
      }
    end
    local term = utils._terminals[key]
    term:open()
    -- send command (clear line first)
    term:send(cmd, true)
    return
  end
  -- Fallback: native terminal split
  local prev_win = vim.api.nvim_get_current_win()
  vim.cmd((opts.direction == "vertical" and "vsplit" or "split"))
  if opts.cwd then pcall(vim.cmd, "lcd " .. vim.fn.fnameescape(opts.cwd)) end
  vim.cmd("terminal " .. cmd)
  -- leave in normal mode after spawning so user can choose
  vim.api.nvim_set_current_win(prev_win)
end

-- export as a global and as module for imports
return utils
