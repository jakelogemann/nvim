# AGENTS Guide (Neovim Config)

This file guides human and automated agents working inside this repo. It is offline‑first, precise, and machine‑friendly. Follow the scope and precedence rules below and keep changes aligned with established patterns.

## Scope & Precedence
- Scope: entire repository (rooted here).
- Precedence: direct developer instructions > this file > README.
- Nested AGENTS.md (if any) overrides sections for paths under its directory.

## Quickstart Checklist
- Read `init.lua` and `lua/custom/plugins/` to understand load order.
- Place new third‑party plugins under `lua/custom/plugins/*.lua` with lazy triggers.
- Keep new runtime modules in `plugin/*.lua` and ensure idempotence/guards.
- Reuse `custom.utils` helpers; avoid heavy work at top level.
- For LSP servers, extend the `servers` table in `custom/plugins/mason.lua`.
- Add/adjust keymaps in `plugin/keymaps.lua` and update which‑key groups.
- Validate: `nvim --headless "+Lazy check" +qa` then `+Lazy sync`, then `+checkhealth`.
- Prefer `vim.fn.executable` and `pcall(require, ...)` for all optional integrations.

## Environment Requirements
- Neovim: 0.9+ (works), 0.10+ recommended. Supports `vim.version()` checks; LSP uses new API when available.
- OS: macOS primary; Linux works (replace `open` with `xdg-open` if extending freeze).
- Binaries (optional/used by features):
  - `git` (lazy.nvim bootstrap, plugin ops)
  - `curl` (Ollama HTTP client)
  - `ollama` (AI prompts; auto-started with `ollama serve` if available)
  - `freeze` (code → image tool in `lua/freeze.lua`)
  - Go toolchain (`go`) for Go helpers; Rust (`cargo`) for Rust keymaps

## Repository Layout
- `init.lua` — bootstraps lazy.nvim, sets leaders, and loads:
  - `utils.try_to_enable_profiler()`
  - `require("freeze").setup()`
  - `require("custom.comment").setup()`
  - `require("ollama_modelfile").setup()`
- `lua/custom/` — shared modules
  - `utils.lua` — notifications, keymap wrappers, shell runner, misc helpers
  - `health.lua` — `require('custom.health').check()` for health output
  - `comment.lua` — lightweight comment toggler
  - `plugins/` — lazy.nvim plugin specs (domain‑grouped)
    - `mason.lua` — LSP servers (mason, mason‑lspconfig, new `vim.lsp.config`)
    - `cmp.lua`, `dap.lua`, `git.lua`, `tree-sitter.lua`, `trouble.lua`, etc.
- `plugin/*.lua` — auto‑sourced runtime modules
  - `options.lua` — core options and globals (idempotent)
  - `keymaps.lua` — central leader bindings + which‑key groups
  - `ollama.lua` — streaming chat integration via local HTTP
  - `go_cmds.lua` — `:GoTest*`, `:GoBuild`, `:GoInstall`
  - `eunuch.lua`, others — small helpers
- `lua/freeze.lua` — wrapper around `freeze` CLI with UI and placeholders
- `screenshots/`, `spell/` — assets and dictionaries
- `lazy-lock.json` — pinned plugin revisions

## Boot & Runtime
- Startup: `init.lua` bootstraps lazy.nvim (cloned under `stdpath('data')/lazy`) and calls `require('lazy').setup('custom/plugins', opts)`.
- Performance: disables some default runtime plugins; optional profiling via `impatient` if installed.
- Auto modules: everything under `plugin/` is sourced on startup (keep lightweight).

## Plugin Patterns (lazy.nvim)
- Place specs in `lua/custom/plugins/` with narrow scope per file.
- Use lazy triggers: `event`, `cmd`, `keys`, `ft` (avoid heavy setup at top‑level).
- Configure via `opts` or `config = function() ... end`.
- Keep dependencies explicit and minimal.
- Validate after edits: `nvim --headless "+Lazy check" +qa`.

### Plugin Spec Contract
- File path: `lua/custom/plugins/<domain>.lua` (snake_case filename).
- Return value: a list of spec tables, e.g., `return { { "author/repo", ... }, ... }`.
- Allowed keys (common): `event`, `cmd`, `ft`, `keys`, `dependencies`, `opts`, `config`, `build`, `enabled`.
- Keep `config` light; prefer `.setup(opts)` and guard with `pcall(require, ...)`.
- Don’t mutate globals except documented `vim.g.*` feature flags.

## LSP & Tools
- Manager: `mason.nvim` + `mason-lspconfig.nvim`.
- Configuration: Prefer `vim.lsp.config[server]` when available (Neovim/lspconfig ≥ 0.11). Fallback to `require('lspconfig')[server].setup(...)` automatically.
- Defaults: `on_attach` keymaps and `capabilities` apply to all Mason‑installed servers via handler or per‑server iteration (guarded for compatibility).
- Tuned servers: `lua_ls`, `yamlls`, `gopls` with inlay hints, analyses, and YAML schema mappings.
- Keymaps (buffer‑local, set on attach): diagnostic nav, rename, code actions, hover, signature help, Snacks picker integrations (with built‑in fallbacks).

### LSP Contract
- Source file: `lua/custom/plugins/mason.lua`.
- Extend `servers[name] = { ... }` for per‑server `settings`.
- Global defaults: apply `on_attach` and `capabilities` to all installed servers.
- API selection:
  - If `vim.lsp.config` exists, merge into `vim.lsp.config[name]`.
  - Else, call `require('lspconfig')[name].setup{ ... }`.
- Compatibility notes:
  - Inlay hints: handle both `vim.lsp.inlay_hint.enable(buf, true)` and legacy `vim.lsp.inlay_hint(buf, true)` forms via `pcall`.
  - `setup_handlers` may be absent on older mason‑lspconfig; fall back to iterating `get_installed_servers()`.

## Keymaps & Leader Namespaces
- Centralized in `plugin/keymaps.lua`.
- Namespaces (via which‑key groups):
  - `<leader>V` neoVIM (Lazy, Mason, profile)
  - `<leader>g` Git (Neogit, Diffview)
  - `<leader>d` Debugger (DAP)
  - `<leader>l` LSP
  - `<leader>o` Ollama
  - `<leader>G` Go, `<leader>r` Rust, `<leader>T` Terminal, others
- Examples:
  - Save: `<C-s>`; Alternate buffer: `<leader><leader>`
  - LSP: `<leader>la` action, `<leader>lf` format, `gd` definition, `gr` references
  - DAP: `<leader>db` breakpoint, `<leader>dc` continue, `<leader>du` UI
  - Ollama: `<leader>op` prompt, `<leader>ox` pick prompt
  - Go: `<leader>Gt`, `<leader>Gf`, Rust: `<leader>rr`, `<leader>rb`

## Snacks Pickers
- Default integration uses `Snacks.picker` with graceful fallbacks when Snacks is missing.
- Common pickers available via keymaps/commands:
  - Files: `Snacks.picker.files()`
  - Grep: `Snacks.picker.grep()`
  - Buffers: `Snacks.picker.buffers()`
  - Recent: `Snacks.picker.recent()`
  - Projects: `Snacks.picker.projects()`
  - Undo: `Snacks.picker.undo()`
  - LSP: `lsp_references()`, `lsp_symbols()`, `lsp_workspace_symbols()`
  - Notifications: `Snacks.picker.notifications()`
  - Commands/Keymaps/Help: `commands()`, `keymaps()`, `help()`

### Keymap Rules
- Define in `plugin/keymaps.lua` using local wrappers; keep descriptions concise.
- Register which‑key groups at the bottom (guard with `pcall`).
- Use selection awareness via helper `_sel_prefix()` for ex‑commands where relevant.

## Custom Utilities (`lua/custom/utils.lua`)
- Notifications: `utils.notify(msg, level, opts)` (namespaced title)
- Keymaps: `utils.nmap(keys, desc, fn)`
- Tables: `utils.default_tbl(opts, default)` deep‑merge
- Shell: `utils.cmd(cmd, show_error?)` returns cleaned stdout on success
- Terminal: `utils.run_in_term(cmd, opts?)` reuses ToggleTerm or fallback split
- Misc: `trim_or_nil`, `pad_string`, `vim_opts`, `emit_event`, `confirm`, `on_or_off`, UI toggles

### Exec/Shell Rules
- Prefer `utils.run_in_term(...)` for long‑running tasks visible to users.
- Prefer `utils.cmd(...)` when you need captured output and success/failure.
- Always sanitize or shell‑escape user‑provided fragments when composing commands.

## Feature Modules
- Freeze (`lua/freeze.lua`):
  - Commands: `:Freeze [range]`, `:FreezeLine`
  - Placeholders in `opts.output`: `{timestamp}`, `{filename}`, `{start_line}`, `{end_line}`
  - Options: `dir` (defaults to detected Downloads), `config` profile, `open` (macOS `open`), `output` template
  - Guards: checks `freeze` binary, shows `vim.notify` warnings
- Ollama (`plugin/ollama.lua`):
  - Streaming via `curl` to `http://<host>:<port>/api/chat`
  - Commands: `:Ollama [PromptName?]` with selection awareness; built‑in prompt set
  - Window: float / split / vsplit; accept/retry/quit maps; optional hidden replace‑in‑place
  - Auto‑start: runs `ollama serve` if available
- Go Helpers (`plugin/go_cmds.lua`): `:GoTest`, `:GoTestFile`, `:GoTestFunc`, `:GoBuild`, `:GoInstall`
- Options (`plugin/options.lua`): idempotent; sets UI, session, and provider toggles. Respects Neovide.

### External Binary Guard Pattern
```lua
if vim.fn.executable("<bin>") ~= 1 then
  vim.notify("`<bin>` not found", vim.log.levels.WARN, { title = "<module>" })
  return
end
```

## Coding Style
- Indentation: 2 spaces; snake_case filenames; trailing commas in tables.
- Doc comments: terse `---@` annotations for non‑obvious logic.
- Keep top‑level cost low (no heavy work during require); defer to `opts`/`config`.
- Respect leader namespaces and update which‑key groups when adding bindings.
- Run `:Format` before committing (project has `.stylua.toml` and `.luacheckrc`).

### Performance Budget
- No heavy loops or network calls at top‑level in modules.
- Defer setup behind lazy triggers (`event`, `ft`, `cmd`, `keys`).
- Use `pcall` and short‑circuit early when optional deps are missing.

## Add a Plugin (Template)
```lua
-- lua/custom/plugins/my_plugin.lua
return {
  {
    "author/repo",
    event = "VeryLazy", -- or ft/cmd/keys
    opts = { /* table of options */ },
    config = function(_, opts)
      local ok, mod = pcall(require, "repo"); if not ok then return end
      mod.setup(opts)
    end,
  },
}
```

## Build & Validation
- Install/update plugins: `nvim --headless "+Lazy sync" +qa`
- Check specs & deps: `nvim --headless "+Lazy check" +qa`
- Health (all/custom): `nvim --headless "+checkhealth" +qa` or `:checkhealth custom`
- Targeted health: `nvim --headless "+lua require('custom.health').check()" +qa`
- Clean artifacts: `mise run clean` (removes `freeze.png`)

## Safety & Guards
- External binaries must be gated with `vim.fn.executable(...) == 1` and fail softly via `vim.notify`.
- Optional dependencies must use `pcall(require, ...)` guards.
- LSP setup: prefer `vim.lsp.config` when present; fallback to `require('lspconfig').setup`.
- Auto modules (`plugin/*.lua`) should be light and idempotent (use one‑shot guards like `vim.g._core_options_applied`).

### Do‑Not List
- Do not replace `plugin/git_signs.lua` with heavy sign plugins; tune existing logic.
- Do not change `mapleader` or leader namespaces without updating which‑key and README.
- Do not add long‑running network operations at startup.
- Do not rename existing files or modules without updating references and README.
- Do not introduce new global variables; prefer local/module scope.

## Common Tasks
- Add an LSP server: extend the `servers` table in `lua/custom/plugins/mason.lua` with `servers["name"] = { settings = ... }`.
- Apply defaults to all servers: handled via mason‑lspconfig handlers or iteration; `on_attach` and `capabilities` are global defaults.
- Add keymaps: edit `plugin/keymaps.lua` and update which‑key groups accordingly.
- Extend Ollama prompts: add to `M.prompts` in `plugin/ollama.lua` (use `$text`, `$filetype`, `$input`, `$register`, `$register_x`).
- Change Freeze output: set `freeze.setup { output = "{filename}-{timestamp}.png", open = true }` in `init.lua` or a dedicated module.

### Change Matrix (what to touch)
- New plugin: `lua/custom/plugins/<domain>.lua` (+ README if user‑facing).
- New keymaps: `plugin/keymaps.lua` (+ which‑key groups).
- LSP tuning: `lua/custom/plugins/mason.lua` (`servers` table).
- Options: `plugin/options.lua` (guard with one‑shot flag).
- AI prompts: `plugin/ollama.lua` (`M.prompts`).

## Contributing & PRs
- Commits: Conventional Commit style, e.g., `feat(nvim): ...`, `fix(lsp): ...`, `docs(readme): ...` (~72 chars).
- Evidence: show headless runs, manual flows, and screenshots for UI/keymap changes.
- Lockfile: regenerate `lazy-lock.json` via lazy.nvim when plugin versions change.
- Optional deps: wrap in `pcall` and degrade gracefully when not installed.

## Troubleshooting
- LSP deprecation warning: fixed by configuring servers via `vim.lsp.config` (fallback included).
- Mason handlers nil: guarded; code iterates installed servers when handlers API is absent.
- Freeze missing: install `freeze` or disable usage; notifications will warn.
- Ollama connection: ensure `ollama serve` is running or reachable on `host:port`.

### Diagnostic Commands
- List plugin specs loaded: `:Lazy`
- Sync plugins headlessly: `nvim --headless "+Lazy sync" +qa`
- Check spec issues: `nvim --headless "+Lazy check" +qa`
- LSP info: `:LspInfo`
- Health: `nvim --headless "+checkhealth" +qa`

## Metadata (machine hints)
- Leaders: `mapleader = " "`, `maplocalleader = " "`.
- Treesitter parsers directory: `vim.g.treesitter_parsers_dir = stdpath('data') .. '/parsers'`.
- Icons enabled flag: `vim.g.icons = true`.
- Spellfile: `stdpath('config') .. '/spell/en.utf-8.add'`.
- Health entrypoint: `require('custom.health').check()`.
 - Feature toggles: `vim.g.cmp_enabled`, `vim.g.autopairs_enabled`, `vim.g.diagnostics_enabled`, `vim.g.autoformat_enabled`.
 - UI: `opt.cmdheight = 0`, `laststatus = 3`, `signcolumn = 'yes:2'`.
