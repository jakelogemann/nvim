-- local welcome_opened = false
local plugin_name = "welcome"
local plugin = {
  name = plugin_name,
  logo = {
    " ███╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
  },
  default_color = "#98c379",
  augroup = vim.api.nvim_create_augroup(plugin_name, {}),
  namespace = vim.api.nvim_create_namespace(plugin_name),
  unlock_buf = function(buf) vim.api.nvim_set_option_value("modifiable", true, { buf = buf }) end,
  lock_buf = function(buf) vim.api.nvim_set_option_value("modifiable", false, { buf = buf }) end,
  screen_height = function(window) return vim.api.nvim_win_get_height(window) - vim.opt.cmdheight:get() end,
  screen_width = function(window) return vim.api.nvim_win_get_width(window) end,
}

local LOGO_WIDTH = 37
local welcome_buff = -1

--- Center and render the ASCII logo inside the welcome buffer.
-- @param buf integer buffer handle
-- @param logo_width integer expected logo width
-- @param logo_height integer number of lines in logo
local function draw_welcome(buf, logo_width, logo_height)
  local window = vim.fn.bufwinid(buf)
  local start_col = math.floor((plugin.screen_width(window) - logo_width) / 2)
  local start_row = math.floor((plugin.screen_height(window) - logo_height) / 2)
  if start_col < 0 or start_row < 0 then return end

  local top_space = {}
  for _ = 1, start_row do
    table.insert(top_space, "")
  end

  local col_offset_spaces = {}
  for _ = 1, start_col do
    table.insert(col_offset_spaces, " ")
  end
  local col_offset = table.concat(col_offset_spaces, "")

  local adjusted_logo = {}
  for _, line in ipairs(plugin.logo) do
    table.insert(adjusted_logo, col_offset .. line)
  end

  plugin.unlock_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 1, 1, true, top_space)
  vim.api.nvim_buf_set_lines(buf, start_row, start_row, true, adjusted_logo)
  plugin.lock_buf(buf)

  vim.api.nvim_buf_set_extmark(buf, plugin.namespace, start_row, start_col, {
    end_row = start_row + #plugin.logo,
    hl_group = "Default",
  })
end

--- Create scratch welcome buffer & make it current, deleting the default.
-- @param default_buff integer previous buffer handle
-- @return integer new buffer handle
local function create_and_set_welcome_buf(default_buff)
  local buf = vim.api.nvim_create_buf("nobuflisted", "unlisted")
  vim.api.nvim_buf_set_name(buf, plugin.name)
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "welcome", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })

  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_delete(default_buff, { force = true })

  return buf
end

--- Apply window-local options suitable for a splash screen.
local function set_options()
  vim.opt_local.number = false -- disable line numbers
  vim.opt_local.relativenumber = false -- disable relative line numbers
  vim.opt_local.list = false -- disable displaying whitespace
  vim.opt_local.fillchars = { eob = " " } -- do not display "~" on each new line
  vim.opt_local.colorcolumn = "0" -- disable colorcolumn
end

--- Redraw handler for resize events (clears and re-centers logo).
local function redraw()
  plugin.unlock_buf(welcome_buff)
  vim.api.nvim_buf_set_lines(welcome_buff, 0, -1, true, {})
  plugin.lock_buf(welcome_buff)
  draw_welcome(welcome_buff, LOGO_WIDTH, #plugin.logo)
end

--- Autocmd callback to display welcome buffer on startup when appropriate.
-- Skips when opening a real file (non-directory) directly.
-- @param payload table VimEnter event data
local function display_welcome(payload)
  local is_dir = vim.fn.isdirectory(payload.file) == 1

  local default_buff = vim.api.nvim_get_current_buf()
  local default_buff_name = vim.api.nvim_buf_get_name(default_buff)
  local default_buff_filetype = vim.api.nvim_get_option_value("filetype", { buf = default_buff })
  if not is_dir and default_buff_name ~= "" and default_buff_filetype ~= plugin.name then return end

  welcome_buff = create_and_set_welcome_buf(default_buff)
  set_options()

  draw_welcome(welcome_buff, LOGO_WIDTH, #plugin.logo)

  vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
    group = plugin.augroup,
    buffer = welcome_buff,
    callback = redraw,
  })
end

--- Initialize highlight + VimEnter autocommand.
-- @param options table|nil { color = '#rrggbb' }
local function setup(options)
  options = options or {}
  vim.api.nvim_set_hl(plugin.namespace, "Default", { fg = options.color or plugin.default_color })
  vim.api.nvim_set_hl_ns(plugin.namespace)

  vim.api.nvim_create_autocmd("VimEnter", {
    group = plugin.augroup,
    callback = display_welcome,
    once = true,
  })
end

setup()
