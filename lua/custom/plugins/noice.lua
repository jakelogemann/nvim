return {
  "folke/noice.nvim",
  lazy = true,
  event = "VeryLazy",
  cmd = { "Noice" },
  main = "noice",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    notify = { enabled = false },
    lsp = {
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      cmdline_output_to_split = false,
      inc_rename = true,
      lsp_doc_border = false,
    },
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
    cmdline = {
      format = {
        search_down = {
          view = "cmdline",
        },
        search_up = {
          view = "cmdline",
        },
      },
    },
  },
}
