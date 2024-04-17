return {
  { -- fast, minimal fuzzy finder for.. everything.
    "nvim-telescope/telescope.nvim",
    lazy = true,
    enabled = true,
    event = "UiEnter",
    keys = {
      { "<f1>", "<cmd>Telescope help_tags<cr>", desc = "Search help topics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "help tags" },
      { "<leader>s/", "<cmd>Telescope builtin<cr>", desc = "available" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "diagnostics" },
      { "<leader>st", "<cmd>Telescope treesitter<cr>", desc = "treesitter" },
      { "<leader>sm", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "find files" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "quickfix" },
      { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "loclist" },
      { "<leader>s`", "<cmd>Telescope marks<cr>", desc = "marks" },
      { "<leader>sb", "<cmd>Telescope buffer<cr>", desc = "buffers" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "commands" },
    },

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          bottom_pane = {
            height = 25,
            preview_cutoff = 120,
            prompt_position = "top",
          },
          center = {
            height = 0.4,
            preview_cutoff = 40,
            prompt_position = "top",
            width = 0.5,
          },
          cursor = {
            height = 0.9,
            preview_cutoff = 40,
            width = 0.8,
          },
          horizontal = {
            height = 0.9,
            preview_cutoff = 120,
            prompt_position = "bottom",
            width = 0.8,
          },
          vertical = {
            height = 0.9,
            preview_cutoff = 40,
            prompt_position = "bottom",
            width = 0.8,
          },
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
  },
}
