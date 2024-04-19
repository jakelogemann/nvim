return {
  {
    -- install/configure treesitter (syntax highlighting but.. better)
    "nvim-treesitter/nvim-treesitter",
    priority = 100,
    lazy = false,
    init = function()
      require("nvim-treesitter.configs").setup {
        -- A list of parser names, or "all"
        ensure_installed = {
          "arduino",
          "astro",
          "bash",
          "c",
          "comment",
          "cpp",
          "css",
          "dockerfile",
          "erlang",
          "fish",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gowork",
          "haskell",
          "hcl",
          "hjson",
          "html",
          "jsonnet",
          "lua",
          "make",
          "markdown",
          "mermaid",
          "nix",
          "proto",
          "python",
          "rst",
          "ruby",
          "rust",
          "scss",
          "sql",
          "svelte",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     init_selection = "<c-space>",
        --     node_incremental = "<c-space>",
        --     scope_incremental = "<c-s>",
        --     node_decremental = "<c-backspace>",
        --   },
        -- },
        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        --     keymaps = {
        --       -- You can use the capture groups defined in textobjects.scm
        --       ["aa"] = "@parameter.outer",
        --       ["ia"] = "@parameter.inner",
        --       ["af"] = "@function.outer",
        --       ["if"] = "@function.inner",
        --       ["ac"] = "@class.outer",
        --       ["ic"] = "@class.inner",
        --     },
        --   },
        --   move = {
        --     enable = true,
        --     set_jumps = true, -- whether to set jumps in the jumplist
        --     goto_next_start = {
        --       ["]m"] = "@function.outer",
        --       ["]]"] = "@class.outer",
        --     },
        --     goto_next_end = {
        --       ["]M"] = "@function.outer",
        --       ["]["] = "@class.outer",
        --     },
        --     goto_previous_start = {
        --       ["[m"] = "@function.outer",
        --       ["[["] = "@class.outer",
        --     },
        --     goto_previous_end = {
        --       ["[M"] = "@function.outer",
        --       ["[]"] = "@class.outer",
        --     },
        --   },
        --   swap = {
        --     enable = true,
        --     swap_next = {
        --       ["<leader>a"] = "@parameter.inner",
        --     },
        --     swap_previous = {
        --       ["<leader>A"] = "@parameter.inner",
        --     },
        --   },
        -- },
      }
    end,
  },

  { -- Parenthesis highlighting
    "p00f/nvim-ts-rainbow",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { -- Autoclose tags
    "windwp/nvim-ts-autotag",
    enable = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { -- Context based commenting
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
-- vim: fdl=1 fen fdm=expr
