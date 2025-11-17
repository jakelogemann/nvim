# Project Overview

This is a Neovim configuration tailored for a modern development workflow, with a focus on Go, Rust, and Lua. It uses `lazy.nvim` for plugin management, ensuring fast startup times with on-demand loading. The user interface is built with Catppuccin, lualine, and which-key, providing a clean and discoverable experience.

Key features include:

*   **Plugin Management:** `lazy.nvim` for efficient plugin loading.
*   **Language Support:** Strong tooling for Go, Rust, and Lua, including LSP, completion, and debugging.
*   **UI:** A modern and friendly interface with themes, a statusline, and keymap hints.
*   **Navigation and Search:** Fast file and text searching capabilities.
*   **Git Integration:** Built-in support for Git workflows.
*   **Local AI:** Integration with Ollama for code assistance.

# Building and Running

This is a Neovim configuration, so there is no build process. To use it, you need to have Neovim 0.9+ installed.

**Installation:**

1.  Clone the repository into your Neovim configuration directory:
    ```bash
    mkdir -p ~/.config/nvim
    cd ~/.config/nvim
    git clone https://github.com/jakelogemann/nvim .
    ```
2.  Start Neovim:
    ```bash
    nvim
    ```
    On the first launch, `lazy.nvim` will bootstrap and install the configured plugins.

**Dependencies:**

*   `git`
*   `ripgrep`
*   `curl`
*   Language toolchains as needed (e.g., `go`, `rustup`, `node`, `python3`)
*   `ollama` (optional, for AI features)
*   `freeze` (optional, for code screenshots)

# Development Conventions

The configuration is structured to be modular and extensible.

*   **Plugin Configuration:** Plugins are defined in `lua/custom/plugins/`. Each file in this directory can return a list of plugins to be loaded by `lazy.nvim`.
*   **Keymaps:** Global keymaps are defined in `plugin/keymaps.lua`.
*   **Custom Modules:** Custom Lua modules are located in `lua/custom/`. These modules provide bespoke functionality, such as comment toggling, utility functions, and AI integration.
*   **Entry Point:** The main entry point is `init.lua`, which bootstraps the plugin manager and loads the initial configuration.

The code style is consistent and well-documented, with a focus on readability and maintainability.
