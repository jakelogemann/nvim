-- Lightweight LSP/diagnostic UI tweaks: rounded borders and sane defaults.
-- Keep this module minimal; it is auto-sourced on startup.

-- Diagnostics float options
vim.diagnostic.config {
  float = {
    border = "rounded",
    source = "if_many",
    focusable = false,
  },
}

-- Wrap open_floating_preview to inject a default border for LSP popups
do
  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    if not opts.border then opts.border = "rounded" end
    return orig(contents, syntax, opts, ...)
  end
end

