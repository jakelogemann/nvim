return {
  {
    "github/copilot.vim",
    lazy = true,
    event = "InsertEnter",
    config = function ()
      vim.cmd [[ imap <silent><script><expr> <M-CR> copilot#Accept("\<CR>") ]]
      vim.g.copilot_no_tab_map = true
    end
  },

  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    enabled = true,
    event = "UiEnter",

    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },

    opts = function(_, opts)
      local cmp = require "cmp"
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      })
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif package.loaded["luasnip"] and require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif package.loaded["luasnip"] and require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      return opts
    end,
  },

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
}
