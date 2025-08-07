local config = {
  -- Define the list of tools to check for on the system.
  tools = {
    "brew",
    "cargo",
    "go",
    "node",
    "npm",
    "npx",
    "pip3",
    "python3",
    "rustc",
    "tree-sitter",
  },
  -- Define the list of LSP servers to check for on the system.
  lsp_servers = {
    "bash-language-server",
    "clangd",
    "gopls",
    "json-lsp",
    "lua-language-server",
    "pyright",
    "rust-analyzer",
    "typescript-language-server",
    "yaml-language-server",
  },
}

local function check_tool(tool)
  if vim.fn.executable(tool) == 1 then
    vim.health.ok(tool .. " is installed")
  else
    vim.health.warn(tool .. " is NOT installed")
  end
end

local function check_lsp(lsp)
  if vim.fn.executable(lsp) == 1 then
    vim.health.ok(lsp .. " is installed")
  else
    vim.health.warn(lsp .. " is NOT installed")
  end
end

return {
  check = function()

    if vim.g.neovide then
      vim.health.info("running in neovide")
    end

    -- Tool detection
    vim.health.start("Tool detection")
    for _, tool in ipairs(config.tools) do
      check_tool(tool)
    end

    -- LSP server detection
    vim.health.start("Language Server Protocol (LSP) detection")
    for _, lsp in ipairs(config.lsp_servers) do
      check_lsp(lsp)
    end

    -- Finally, check a few miscellaneous things.
    vim.health.start("Sanity checks")
    vim.health.info("config dir is " .. vim.fn.stdpath("config"))
    vim.health.info("data dir is " .. vim.fn.stdpath("data"))
    vim.health.info("cache dir is" .. vim.fn.stdpath("cache"))

    -- Spell file checks
    local spell_dir = vim.fn.stdpath("config") .. "/spell"
    local spell_files = vim.fn.glob(spell_dir .. "/*.utf-8.add", true, true)
    if #spell_files > 0 then
      for _, file in ipairs(spell_files) do
        vim.health.ok("Spell file found: " .. file)
      end
    else
      vim.health.warn("No spell files found in ./spell/*.utf-8.add (" .. spell_dir .. ")")
    end
    -- Thesaurus check
    local thesaurus_path = spell_dir .. "/thesaurus.txt"
    if vim.fn.filereadable(thesaurus_path) == 1 then
      vim.health.ok("Thesaurus file found")
    else
      vim.health.warn("Thesaurus file not found at ./spell/thesaurus.txt (" .. thesaurus_path .. ")")
    end

    -- Clipboard support
    if vim.fn.has("clipboard") == 1 then
      vim.health.ok("Clipboard integration available")
    else
      vim.health.warn("Clipboard integration NOT available")
    end

    -- Terminal integration
    if vim.fn.has("nvim") == 1 and vim.fn.has("terminal") == 1 then
      vim.health.ok("Terminal integration available")
    else
      vim.health.warn("Terminal integration NOT available")
    end
  end,
}
