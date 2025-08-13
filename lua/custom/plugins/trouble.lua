return {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle" },
  keys = {
    { "<leader>xx", function() require("trouble").toggle() end, desc = "trouble: toggle" },
    { "<leader>xw", function() require("trouble").toggle "workspace_diagnostics" end, desc = "trouble: workspace" },
    { "<leader>xd", function() require("trouble").toggle "document_diagnostics" end, desc = "trouble: document" },
    { "<leader>xq", function() require("trouble").toggle "quickfix" end, desc = "trouble: quickfix" },
    { "<leader>xl", function() require("trouble").toggle "loclist" end, desc = "trouble: loclist" },
    { "gR", function() require("trouble").toggle "lsp_references" end, desc = "trouble: references" },
  },
  opts = { use_diagnostic_signs = true },
}
