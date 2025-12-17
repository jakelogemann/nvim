-- =====================================================================
-- lua/ollama_modelfile.lua
--
-- Single-file Neovim setup for Ollama Modelfiles:
-- - Filetype detection (Modelfile, *.modelfile, etc.)
-- - Buffer-local options (ftplugin equivalent)
-- - Regex-based highlighting (syntax equivalent)
--
-- Install:
--   1) Save as: ~/.config/nvim/lua/ollama_modelfile.lua
--   2) Call it from init.lua: require("ollama_modelfile").setup()
-- =====================================================================

local M = {}

-- ---------------------------------------------------------------------
-- Constants: filetype name + patterns
-- ---------------------------------------------------------------------
local FT = "ollama_modelfile"

local PATTERNS = {
  ["Modelfile"] = FT,
  ["*.modelfile"] = FT,
  ["*.Modelfile"] = FT,
  ["*.ollama.modelfile"] = FT,
}

-- ---------------------------------------------------------------------
-- Helper: safe pcall wrapper for APIs that may throw in older versions
-- ---------------------------------------------------------------------
local function safe_call(fn, ...)
  local ok, res = pcall(fn, ...)
  return ok, res
end

-- ---------------------------------------------------------------------
-- Highlight groups
--
-- We link to builtins where possible to respect colorschemes.
-- ---------------------------------------------------------------------
local function define_highlights()
  -- NOTE: Use links, not explicit colors, so themes control the palette.
  local set = vim.api.nvim_set_hl
  set(0, "OllamaComment", { link = "Comment" })
  set(0, "OllamaInstr", { link = "Keyword" })
  set(0, "OllamaFromValue", { link = "String" })
  set(0, "OllamaParamName", { link = "Identifier" })
  set(0, "OllamaNumber", { link = "Number" })
  set(0, "OllamaBool", { link = "Boolean" })
  set(0, "OllamaString", { link = "String" })
  set(0, "OllamaEscape", { link = "SpecialChar" })
  set(0, "OllamaTripleDelim", { link = "Delimiter" })
  set(0, "OllamaTemplateDelim", { link = "Delimiter" })
  set(0, "OllamaTemplateVar", { link = "Special" })
  set(0, "OllamaRole", { link = "Type" })
  set(0, "OllamaBadTab", { link = "Error" })
end

-- ---------------------------------------------------------------------
-- Regex highlight rules via matchadd()
--
-- This is not a full parser. It's a pragmatic set of patterns.
-- matchadd() applies per-window; we attach per-buffer and clean up.
-- ---------------------------------------------------------------------
local function add_matches(bufnr)
  -- Ensure we do not re-add matches on repeated events
  if vim.b[bufnr].ollama_modelfile_matches then
    return
  end
  vim.b[bufnr].ollama_modelfile_matches = {}

  local function add(group, pattern, priority)
    priority = priority or 10
    -- matchadd() works in the current window; matchaddpos() is different.
    -- We'll add matches for the current window; then also add for new windows
    -- via WinEnter autocmd below.
    local id = vim.fn.matchadd(group, pattern, priority)
    table.insert(vim.b[bufnr].ollama_modelfile_matches, id)
  end

  -- Comments
  add("OllamaComment", [[^\s*#.*]])

  -- Instruction keywords at BOL
  add("OllamaInstr", [[^\s*\zs\(FROM\|PARAMETER\|TEMPLATE\|SYSTEM\|ADAPTER\|LICENSE\|MESSAGE\)\ze\>]], 20)

  -- FROM value (rest of line)
  add("OllamaFromValue", [[^\s*FROM\>\s\+\zs.*$]])

  -- PARAMETER name (first token after PARAMETER)
  add("OllamaParamName", [[^\s*PARAMETER\>\s\+\zs[A-Za-z_][A-Za-z0-9_-]*]], 25)

  -- MESSAGE role token
  add("OllamaRole", [[^\s*MESSAGE\>\s\+\zs\(system\|user\|assistant\|SYSTEM\|USER\|ASSISTANT\)\ze\>]], 25)

  -- Numbers / booleans (loose)
  add("OllamaNumber", [[\v(^|[\s=])\zs-?\d+(\.\d+)?\ze($|[\s,])]])
  add("OllamaBool", [[\v(^|[\s=])\zs(true|false|TRUE|FALSE)\ze($|[\s,])]])

  -- Quoted strings (simple)
  add("OllamaString", [["\([^"\\]\|\\.\)*"]], 15)
  add("OllamaEscape", [[\\.]]

  )

  -- Triple quote delimiters """ (content is not separately highlighted via matchadd;
  -- we at least emphasize the delimiters)
  add("OllamaTripleDelim", [[\"\"\" ]]) -- also catches """ inside lines
  add("OllamaTripleDelim", [[\"\"\" ]], 30) -- extra priority
  add("OllamaTripleDelim", [[\"\"\" ]], 30)

  -- Template delimiters + dot-vars (common in TEMPLATE blocks)
  add("OllamaTemplateDelim", [[{{\|}}]], 30)
  add("OllamaTemplateVar", [[\v\.\w+(\.\w+)*]], 18)

  -- Leading tabs (mild lint)
  add("OllamaBadTab", [[^\t\+]], 5)
end

local function clear_matches(bufnr)
  local ids = vim.b[bufnr].ollama_modelfile_matches
  if type(ids) ~= "table" then
    return
  end
  for _, id in ipairs(ids) do
    pcall(vim.fn.matchdelete, id)
  end
  vim.b[bufnr].ollama_modelfile_matches = nil
end

-- ---------------------------------------------------------------------
-- Buffer-local options (ftplugin equivalent)
-- ---------------------------------------------------------------------
local function set_ft_options(bufnr)
  vim.bo[bufnr].commentstring = "# %s"
  vim.bo[bufnr].tabstop = 2
  vim.bo[bufnr].shiftwidth = 2
  vim.bo[bufnr].softtabstop = 2
  vim.bo[bufnr].expandtab = true

  -- Prefer not auto-wrapping these directive-y files by default
  vim.wo.wrap = false

  -- Disable auto-text formatting but keep sane comment behavior
  -- (formatoptions is local to buffer, but edited via string ops)
  local fo = vim.bo[bufnr].formatoptions
  fo = fo:gsub("t", "") -- don't auto-wrap text
  if not fo:find("c", 1, true) then fo = fo .. "c" end
  if not fo:find("r", 1, true) then fo = fo .. "r" end
  if not fo:find("o", 1, true) then fo = fo .. "o" end
  if not fo:find("q", 1, true) then fo = fo .. "q" end
  if not fo:find("l", 1, true) then fo = fo .. "l" end
  vim.bo[bufnr].formatoptions = fo
end

-- ---------------------------------------------------------------------
-- Setup: filetype + autocommands
-- ---------------------------------------------------------------------
function M.setup()
  -- 1) Filetype detection (Neovim-native)
  safe_call(vim.filetype.add, {
    filename = {
      ["Modelfile"] = FT,
    },
    pattern = {
      [".*%.modelfile"] = FT,
      [".*%.Modelfile"] = FT,
      [".*%.ollama%.modelfile"] = FT,
    },
  })

  -- 2) Highlights (link-based so themes remain in control)
  define_highlights()

  -- 3) Autocmd: when a buffer is assigned this filetype, configure it + highlight it
  local aug = vim.api.nvim_create_augroup("OllamaModelfile", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    pattern = FT,
    callback = function(args)
      local bufnr = args.buf

      set_ft_options(bufnr)

      -- matchadd() applies per-window. Ensure we're in a window showing this buffer.
      -- At FileType time we usually are, but let's still do the straightforward thing.
      add_matches(bufnr)

      -- Clean up on buffer wipeout to avoid leaking match IDs.
      vim.api.nvim_create_autocmd({ "BufWipeout", "BufUnload" }, {
        group = aug,
        buffer = bufnr,
        callback = function(ev)
          clear_matches(ev.buf)
        end,
        once = true,
      })
    end,
  })

  -- 4) If the same buffer is shown in a *new window*, matchadd() needs to be applied there too.
  -- We'll re-apply (but guarded) on WinEnter for the active buffer if it is our filetype.
  vim.api.nvim_create_autocmd("WinEnter", {
    group = aug,
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.bo[bufnr].filetype ~= FT then
        return
      end
      -- Re-add matches for the new window if needed.
      -- Our guard is per-buffer, so if you want per-window IDs, you'd store a map by winid.
      -- Pragmatic approach: clear and re-add for this window.
      clear_matches(bufnr)
      add_matches(bufnr)
    end,
  })
end

return M
