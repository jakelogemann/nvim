# GitHub Copilot Instructions for `jakelogemann/nvim`

These notes are for AI coding agents working inside this Neovim config.
Keep them short, concrete, and aligned with how this repo already works.

## Big picture

- **Purpose**: This is a full Neovim configuration, not a plugin. `init.lua` bootstraps [lazy.nvim] and wires in a set of custom modules for UI, LSP, git, AI (Ollama), Go helpers, terminals, and more.
- **Entry point**: `init.lua` sets up the lazy plugin manager and then calls `utils.try_to_enable_profiler()`, `require("freeze").setup()`, and `require("custom.comment").setup()`.
- **Plugin specs**: All lazy.nvim plugin specs live under `lua/custom/plugins/` (see `lua/custom/plugins/init.lua` plus per-area files like `cmp.lua`, `dap.lua`, `git.lua`, `lualine.lua`, etc.). New plugins or changes to plugin behaviour should be expressed as lazy.nvim specs here.
- **Runtime config**: Neovim auto-sources Lua in `plugin/*.lua` on startup. This directory contains config for options, keymaps, autocmds, Ollama integration, git signs, Go commands, etc. New runtime behaviour that isn’t a plugin spec usually belongs here.
- **Custom helpers**: Cross-cutting utilities live in `lua/custom/*.lua` (e.g. `utils.lua`, `comment.lua`, `health.lua`, `freeze.lua`). Prefer extending these over scattering ad-hoc helpers.

## Architectural patterns

- **lazy.nvim as the "container"**: All third‑party plugins should be declared as lazy.nvim specs. Follow existing patterns in `lua/custom/plugins/*.lua` (key fields: `event`, `cmd`, `keys`, `opts`, `config`, `dependencies`, `ft`). Use `opts` and `config` rather than configuring plugins directly from `plugin/*.lua`.
- **Small focused modules**: Custom modules are narrow in scope (e.g. `plugin/git_signs.lua`, `plugin/go_cmds.lua`, `plugin/ollama.lua`). When adding new features, create a focused module instead of bloating unrelated files.
- **Utility-first helpers**: `lua/custom/utils.lua` centralises helpers for keymaps, notifications, shell commands, terminal integration, and small UI toggles. Reuse these helpers instead of re-implementing `vim.keymap.set`, `vim.fn.system`, or terminal logic.
- **Selection-aware tools**: Tools like the Ollama integration (`plugin/ollama.lua`) and Freeze (`lua/freeze.lua`) work on visual ranges or whole buffers and carefully manage buffers, windows and jobs. When extending these, preserve existing state-handling patterns (`globals`, `reset`, `create_window`, etc.).
- **Keybinding conventions**: Leader is space. Keymaps are grouped and discoverable via which‑key; see `plugin/keymaps.lua` and plugin specs that set `keys`. Keep new mappings consistent with the existing leader groups (e.g. `\<leader>g` for git, `\<leader>d` for debug, `\<leader>o` for AI).

## Developer workflows

- **Bootstrapping**: `init.lua` will clone lazy.nvim if missing and then run `require("lazy").setup("custom/plugins", options)`. You generally do **not** need to modify this unless changing plugin-manager behaviour.
- **Plugin management**: Use the keymaps described in README (`<leader>Vl`, `<leader>Vs`, `<leader>Vu`, `<leader>Vm` etc.) or `:Lazy` directly. New plugins should be added as specs, not hard-coded `packer`/`vim-plug` style calls.
- **Linting / formatting**: This repo ships `.stylua.toml` and `.luacheckrc`. When editing Lua, keep style compatible with these tools (e.g. 2‑space indents, tables split like existing files). If you add code constructs that break current linting, adjust them minimally.
- **Terminal / command helpers**: For running external commands from Lua, prefer `utils.cmd` (capture output) or `utils.run_in_term` (integrated terminal, using ToggleTerm when available) over bare `vim.fn.system` or `vim.cmd("terminal ...")`.
- **Performance**: Keep modules small and lazy‑loaded where possible. Use `event`, `ft`, or `cmd` triggers in plugin specs instead of eager loading, and avoid heavy work in top-level scope of `plugin/*.lua`.

## Project-specific conventions

- **File layout**:
  - `init.lua`: core bootstrap and global setup.
  - `lua/custom/plugins/`: lazy.nvim plugin specs organised by concern (`init.lua` for generic/misc, plus files like `cmp.lua`, `dap.lua`, `git.lua`, `tree-sitter.lua`, etc.).
  - `plugin/*.lua`: config modules auto-loaded by Neovim (keymaps, options, git signs, Go commands, Ollama, welcome, etc.).
  - `lua/custom/*.lua`: shared helpers and custom logic (`utils.lua`, `comment.lua`, `health.lua`, `freeze.lua`).
  - `spell/`: spelling additions and thesaurus.
- **Docstrings / comments**: Existing modules use concise doc-comments (often EmmyLua-style `---@` annotations) to describe functions. When adding non‑obvious logic, mirror this style rather than large prose blocks.
- **Error handling**: Many helpers fail soft (e.g. `try_to_enable_profiler` uses `pcall`, Ollama setup uses `pcall(io.popen, ...)`). Prefer non‑crashing behaviour on missing optional tools or binaries.

## Working with key features

- **Ollama integration** (`plugin/ollama.lua`):
  - Uses a `default_options` table and `M.setup(opts)` to configure models, host/port, prompt behaviour, window mode, and keymaps.
  - Maintains transient state in a `globals` table and exposes a high-level `M.exec(options)` entry point that reads the current buffer / selection, builds a JSON body, and streams via `curl`.
  - When extending it (e.g. new commands or display modes), keep the streaming and selection‑replacement logic intact, and wire new behaviour through options rather than duplicating the job-handling code.
- **Freeze screenshots** (`lua/freeze.lua`): wraps an external `freeze` CLI; any enhancements should respect its existing command templates and output paths.
- **Git signs** (`plugin/git_signs.lua`): a custom lightweight diff gutter; avoid pulling in heavy full-featured alternatives here unless explicitly requested.
- **Go helpers** (`plugin/go_cmds.lua`): provide language-specific runner commands and keymaps; follow this pattern if adding helpers for another language.

## How to extend safely

- Prefer **adding** plugin specs or small modules over rewriting `init.lua` or large existing files.
- When introducing new user-facing commands or keymaps, document them briefly in README-style comments or keep them grouped near similar existing mappings.
- Use existing helper modules (`custom.utils`, `custom.comment`, etc.) when integrating new functionality, and avoid introducing alternative patterns unless necessary.

[lazy.nvim]: https://github.com/folke/lazy.nvim
