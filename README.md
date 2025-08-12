# ✨ Jake's Neovim Configuration

[![Neovim 0.9+](https://img.shields.io/badge/Neovim-0.9%2B-57A143?logo=neovim)](https://neovim.io)
[![macOS](https://img.shields.io/badge/macOS-✓-000000?logo=apple)](https://www.apple.com/macos)
[![lazy.nvim](https://img.shields.io/badge/Plugin%20Manager-lazy.nvim-blue)](https://github.com/folke/lazy.nvim)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Lua](https://img.shields.io/badge/Lua-%E2%99%A5-000080?logo=lua)](https://www.lua.org)
[![Go Ready](https://img.shields.io/badge/Go-ready-29BEB0?logo=go)](https://go.dev)
[![Rust Ready](https://img.shields.io/badge/Rust-ready-000?logo=rust)](https://www.rust-lang.org)
[![Ollama](https://img.shields.io/badge/AI-Ollama-6C4CF5)](https://github.com/ollama/ollama)
[![Treesitter](https://img.shields.io/badge/Parsing-Treesitter-5eaa2f)](https://github.com/nvim-treesitter/nvim-treesitter)

A lean, fast, and developer‑friendly Neovim setup built around **[lazy.nvim](https://github.com/folke/lazy.nvim)** with first‑class support for Go, Rust, Lua, YAML, Markdown, and more. It blends powerful defaults, thoughtful UX tweaks, and a few bespoke plugins (welcome screen, lightweight git signs, AI / Ollama integration, screenshotting code, etc.) to keep you in flow.

> 🧪 Targeted at Neovim 0.9+ (works great on 0.10). macOS focused but portable.

---

## 🚀 Highlights

- ⚡ **Fast startup** via lazy loading & optional profiler hook.
- 🎨 **Beautiful UI**: Catppuccin theme, minimal status, floating terminals, curated UI plugins.
- 🧠 **Smart editing**: Treesitter highlighting, surround, commenting, structural search & replace.
- 💻 **Language tooling**: Mason + LSPConfig auto‑installs; rich LSP keymaps & inlay hints.
- 🐛 **Debugging built in**: `nvim-dap` + UI + Go debug helpers.
- 🧵 **Completion & snippets**: `nvim-cmp` + LuaSnip + Copilot (optional).
- 🗂️ **File navigation**: [`oil.nvim`](https://github.com/stevearc/oil.nvim) (buffer‑centric file explorer) + Telescope wrapper.
- 🔍 **Find everything** with Telescope + custom `:Find {file|buffer|help|...}` dispatcher.
- 🧭 **Session & project smarts**: Persistence, Neoconf, SchemaStore, yaml schema mapping.
- 🧪 **Custom lightweight Git signs** (no dependency bloat, just diff marks + toggle).
- 🤖 **Local AI integration** with Ollama prompt workflows (enhance code, review, summarize, etc.).
- 🖼️ **Freeze CLI integration**: snapshot code selection to a styled image (great for sharing).
- 👋 **Custom splash / welcome screen** drawn & centered dynamically.
- 🧩 **Ergonomic keymaps** (discoverable w/ which‑key groups) and pragmatic defaults.

---

## 📦 Core Plugin Snapshot

Focuses on: UI (catppuccin, dressing), editing (mini.surround, ssr, spread, treesitter), navigation (oil, telescope, diffview, symbols‑outline), terminal (toggleterm), completion & AI (cmp + LuaSnip + copilot + lspkind), LSP/tooling (lspconfig, mason, neodev, schemastore, neoconf, persistence, trouble), debugging (dap + dap-ui + dap-go + virtual-text + nio), language extras (vim-go, typr), local AI (custom Ollama integration), and a bespoke minimal git signs module.

---

## 🛠️ Built‑In Custom Modules

welcome (splash) · git_signs (lean diff marks) · ollama (AI prompts) · comment (lightweight toggler) · freeze (code snapshot via CLI) · utils (helpers / term runner).

---

## ⌨️ Keymap Sampler

Leader is `<Space>` (also local leader).

| Action | Keys | Notes |
| ------ | ---- | ----- |
| File explorer | `-` or `<leader>e` | Opens Oil (directory buffer). |
| Telescope find files | `<leader>ff` | Global project search. |
| Live grep | `<leader>fg` | Ripgrep via Telescope. |
| Toggle terminal (float) | `<leader>\`` / `<leader>zt` | Uses `<C-Space>` to toggle when in insert/normal. |
| Session restore | `<leader>ps` / `<leader>pS` | Load last / previous session. |
| Diff view open / close | `<leader>gd` / `<leader>gq` | Uses diffview.nvim. |
| LSP rename | `<leader>lr` | Contextual symbol rename. |
| LSP code action | `<leader>la` | Quick actions. |
| Diagnostics float | `<leader>ld` | Under-cursor diagnostics. |
| Debugger continue | `<leader>dc` | DAP control suite under `<leader>d*`. |
| Toggle git signs | `<leader>zg` | Calls custom toggle. |
| Comment toggle | `<leader>c` (normal/visual) | Provided by custom comment module. |
| Run current file | `<leader>xx` | Dispatch by filetype (Go, Rust, Python, Shell). |
| AI Prompt (Ollama) | `<leader>op` etc. | Review: `<leader>or`, Enhance: `<leader>oe`, Change: `<leader>oc`. |
| Symbols outline | `<leader>zo` | Right side tree. |

Discover groups via which‑key (if installed) by pressing `<leader>`.

---

## 🧠 LSP / Completion Quick Notes

Mason auto‑installs servers; inlay hints enabled when available. `:Format` buffer command. YAML schemas pre‑mapped (actions, catalog, ansible). Completion: cmp + LuaSnip + Copilot (`<M-CR>` accept). Go: import organize on save + dap‑go helpers. Rust: cargo shortcuts.

---

## 🐛 DAP Keys

`<space>b` breakpoint · `<space>gb` run to cursor · `<F1>` continue · `<F2>/<F3>/<F4>/<F5>` step into/over/out/back · `<space>?` eval · `<leader>du` UI toggle. Virtual text auto‑redacts likely secrets.

---

## 🤖 Ollama Workflow

Use `<leader>o*` mappings or `:Ollama` to select a prompt:

- Enhancements, change requests, code review, summarization.
- Works on visual selection or current buffer.
- Streaming output in a floating window with accept (`<C-CR>`), retry (`<C-R>`), or quit (`q`).
- Extracts code blocks back into buffer for certain transforms.

Ensure the [Ollama](https://github.com/ollama/ollama) daemon is running (`ollama serve`). The integration auto-attempts to start it if not.

---

## 🖼️ Freeze: Code Snapshotting

Install the external `freeze` CLI (provide your own implementation or preferred binary). Then:

- `:Freeze` — snapshot whole file or a visual range (use `:'<,'>Freeze`).
- `:FreezeLine` — snapshot current line.
- Configurable filename template with placeholders `{timestamp}`, `{filename}`, `{start_line}`, `{end_line}`.
- Optional auto-open (macOS `open`).

---

## 🧪 Minimal Git Signs

Custom `git_signs.lua` avoids dependencies and just renders:

- `+` additions
- `~` changes
- `-` deletions (placed at logical target line)

Efficiently debounced and safe on large files (auto-bails). Toggle on/off: `:GitSignsToggle` or mapping `<leader>zg`.

---

## 🧰 Options & UX Tweaks

Some notable `:set` decisions (see `plugin/options.lua`):

- `cmdheight = 0` modern minimal command line.
- Global statusline (`laststatus = 3`).
- Conceal enabled by default (`conceallevel = 2`) with toggle `<leader>zc`.
- Persistent undo & smart splits (`splitright`, no `wrap` by default).
- Icons + Nerd Font assumed (`vim.g.icons = true`).

---

## 📂 Structure Overview

```text
init.lua                -- bootstrap lazy + core modules
lua/custom/plugins/     -- plugin specs grouped (core, lsp, cmp, ui, etc.)
plugin/*.lua            -- runtime plugin-specific config (auto-sourced)
lua/custom/*.lua        -- utilities & bespoke modules (comment, utils)
lua/freeze.lua          -- freeze CLI wrapper
spell/                  -- custom spelling + thesaurus
```

---

## 🛫 Quick Start

```bash
# clone into a config directory (example: custom clone path)
mkdir -p ~/.config/nvim
cd ~/.config/nvim
# (or use this repo directly)
# git clone https://github.com/jakelogemann/nvim .

# first launch
nvim
# lazy.nvim will auto-bootstrap and install plugins
```

Recommended system packages:

- `ripgrep` (live grep)
- `git`
- `curl` (Ollama integration transport)
- `go`, `rustup`, `node`, `python3` (language tooling as needed)
- `ollama` (optional AI)
- `freeze` (optional code snapshotting)

---

## 🧩 Customization Tips

- Add or remove plugins in `lua/custom/plugins/*.lua` (separated by concern).
- Override theme: change the `catppuccin` variant in its config block.
- Adjust keymaps in `plugin/keymaps.lua` (single source of truth).
- Toggle features via global vars in `plugin/options.lua` (e.g. `vim.g.autoformat_enabled`).

---

## 🔍 Troubleshooting

| Symptom | Suggestion |
| ------- | ---------- |
| Missing syntax or LSP | Run `:Mason` and ensure tools installed. |
| Slow startup | Temporarily enable profiler (impatient) if installed. |
| No AI responses | Verify `ollama serve` running & model pulled. |
| Git signs missing | Run inside a git repo & ensure file is tracked. |

---

## 📜 License & Attribution

This configuration aggregates open source plugins (each under their own license). See linked repositories for details. Custom Lua modules in this repo are MIT unless otherwise noted.

---

## ❤️ Thanks

Huge thanks to the Neovim ecosystem & plugin authors for the tooling that makes this setup possible.

Happy hacking! 🛠️
