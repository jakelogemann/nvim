--- Unified wrappers around Snacks pickers with safe fallbacks.
-- Provides consistent project root resolution and lazy loading.
-- @module custom.pick
local M = {}

local cached_picker -- memoize Snacks.picker when available

--- Best-effort project root resolution for a buffer.
-- Order: git root > first LSP client root/workspace > file directory.
-- @param bufnr integer|nil
-- @return string absolute path
function M.root(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  local dir = file ~= "" and vim.fn.fnamemodify(file, ":p:h") or vim.loop.cwd()

  -- git root
  if vim.fn.executable "git" == 1 and dir and dir ~= "" then
    local out = vim.fn.systemlist { "git", "-C", dir, "rev-parse", "--show-toplevel" }
    if type(out) == "table" and out[1] and out[1] ~= "" then return out[1] end
  end

  -- LSP workspace
  local clients = vim.lsp and vim.lsp.get_clients and vim.lsp.get_clients { bufnr = bufnr } or {}
  if #clients > 0 then
    local c = clients[1]
    if c and c.root_dir and c.root_dir ~= "" then return c.root_dir end
    if c and c.workspace_folders and c.workspace_folders[1] and c.workspace_folders[1].name then
      return c.workspace_folders[1].name
    end
  end

  return dir
end

--- Try to obtain Snacks.picker and memoize it. Returns nil when unavailable.
-- @return table|nil Snacks.picker
function M.ensure()
  if cached_picker ~= nil then return cached_picker end
  local ok_mod, mod = pcall(require, "snacks")
  if ok_mod and mod and mod.picker then
    cached_picker = mod.picker
  elseif _G.Snacks and _G.Snacks.picker then
    cached_picker = _G.Snacks.picker
  else
    cached_picker = nil
  end
  return cached_picker
end

-- Core pickers ------------------------------------------------------------

function M.files(opts)
  opts = opts or {}
  local root = opts.cwd or M.root()
  opts.cwd = root
  local p = M.ensure()
  if p then
    -- Prefer git_files inside a git worktree when available
    local in_git = false
    if vim.fn.executable "git" == 1 then
      local out = vim.fn.systemlist { "git", "-C", root, "rev-parse", "--is-inside-work-tree" }
      in_git = (vim.v.shell_error == 0) and (out[1] == "true")
    end
    if in_git and p.git_files then return p.git_files(opts) end
    if p.files then return p.files(opts) end
  end
  -- fallback
  vim.cmd("find ")
end

function M.grep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or M.root()
  local p = M.ensure()
  if p and p.grep then
    return p.grep(opts)
  end
  vim.notify("Snacks grep unavailable", vim.log.levels.WARN)
end

function M.buffers(opts)
  local p = M.ensure()
  if p and p.buffers then return p.buffers(opts or {}) end
  vim.cmd.buffers()
end

function M.recent(opts)
  local p = M.ensure()
  if p and p.recent then return p.recent(opts or {}) end
end

function M.projects(opts)
  local p = M.ensure()
  if p and p.projects then return p.projects(opts or {}) end
end

function M.undo(opts)
  local p = M.ensure()
  if p and p.undo then return p.undo(opts or {}) end
end

function M.notifications(opts)
  local p = M.ensure()
  if p and p.notifications then return p.notifications(opts or {}) end
end

-- LSP pickers -------------------------------------------------------------

function M.lsp_references(opts)
  local p = M.ensure()
  if p and p.lsp_references then return p.lsp_references(opts or {}) end
  return vim.lsp.buf.references()
end

function M.lsp_symbols(opts)
  local p = M.ensure()
  if p and p.lsp_symbols then return p.lsp_symbols(opts or {}) end
  return vim.lsp.buf.document_symbol()
end

function M.lsp_workspace_symbols(opts)
  local p = M.ensure()
  if p and p.lsp_workspace_symbols then return p.lsp_workspace_symbols(opts or {}) end
  return vim.lsp.buf.workspace_symbol()
end

--- Smart find: prefer Snacks smart, else grep word under cursor or files.
-- @param opts table|nil
function M.smart(opts)
  opts = opts or {}
  local p = M.ensure()
  if p and p.smart then return p.smart(opts) end
  local root = M.root()
  local w = vim.fn.expand "<cword>"
  if type(w) == "string" and #w >= 3 then
    return M.grep { cwd = root, default = w }
  end
  return M.files { cwd = root }
end

return M
