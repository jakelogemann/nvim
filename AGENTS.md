# Repository Guidelines

## Project Layout
This repo is a batteries-included Neovim config. `init.lua` bootstraps lazy.nvim, applies globals, and invokes `utils.try_to_enable_profiler()`, `require("freeze").setup()`, and `require("custom.comment").setup()`. Plugin specs live in `lua/custom/plugins/` (grouped by domain such as cmp, dap, git). Auto-sourced runtime modules sit in `plugin/*.lua` for options, keymaps, Ollama, git signs, Go helpers, and more. Shared helpers live in `lua/custom/`, while `screenshots/`, `spell/`, and `lazy-lock.json` cover assets and pinned revisions.

## Patterns & Workflows
Declare third-party plugins as lazy specs with meaningful `event`, `cmd`, `keys`, or `ft` triggers and configure them via `opts`/`config`. Keep modules narrow in scope, reuse `custom.utils` helpers (`cmd`, `run_in_term`, keymap wrappers, notifications), and leave heavy work out of top-level scope. Selection-aware tools (Ollama, Freeze) already manage visual ranges and window state—extend them by feeding new options into existing handlers rather than duplicating job logic. Manage plugins with `<leader>V{l,s,u,m}` or `:Lazy`; bootstrapping happens automatically.

## Build & Validation
- `nvim --headless "+Lazy sync" +qa` — install or update plugins after spec edits.
- `nvim --headless "+Lazy check" +qa` — verify metadata and missing dependencies.
- `nvim --headless "+checkhealth" +qa` or `:checkhealth custom` — run built-in and custom diagnostics.
- `nvim --headless "+lua require('custom.health').check()" +qa` — target the health module.
- `mise run clean` — remove the generated `freeze.png` artifact.

## Style & Tooling
Use two-space indentation, snake_case filenames, and trailing-table commas; run `:Format` before committing. Keep changes compatible with `.stylua.toml` and `.luacheckrc`, and mirror the terse `---@` doc-comment style when explaining non-obvious logic. Respect leader namespaces surfaced by which-key (`<leader>g` git, `<leader>d` debug, `<leader>o` AI, `<leader>V` plugin tooling) and update captions when adding bindings.

## Feature Modules
Guard external binaries in `plugin/ollama.lua`, `plugin/go_cmds.lua`, and `lua/freeze.lua` with `vim.fn.executable`, reporting issues through `vim.notify`. `plugin/git_signs.lua` is a bespoke lightweight gutter—tune it carefully instead of replacing it with heavier plugins. When adding language helpers, mirror the Go module by wrapping CLI calls, reusing `custom.utils`, and wiring leader keymaps.

## Collaboration
Commit messages follow Conventional Commit patterns (`feat(nvim): …`, `docs(readme): …`) with ~72 character summaries. Document testing evidence (headless commands, manual flows) in PRs, add reproduction steps for async features (Ollama streaming, DAP, git signs), and include screenshots or recordings when UI or keymaps change. Regenerate `lazy-lock.json` via lazy.nvim, register new modules in `init.lua` or `plugin/`, fail softly with `pcall` when dependencies are optional, and keep the README in sync with user-facing changes.
