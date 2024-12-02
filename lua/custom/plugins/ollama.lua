return {
  {
    "nomnivore/ollama.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },

    cmd = {
      "Ollama",
      "OllamaModel",
      "OllamaServe",
      "OllamaServeStop",
    },

    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "ollama prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>oe",
        ":<c-u>lua require('ollama').prompt('Explain_Code')<cr>",
        desc = "explain code",
        mode = { "n", "v" },
      },
      {
        "<leader>og",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "generate code",
        mode = { "n", "v" },
      },
    },

    opts = function(_, opts)
      opts = require("ollama").default_config() -- start from the default config.
      opts.model = "codestral"
      opts.prompts.Example_001 = {
        prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
        input_label = "> ",
        model = "mistral",
        action = "display",
      }
      return opts -- finally, be sure to return the opts value.
    end,
  },
  {
    "David-Kunz/gen.nvim",
    lazy = true,

    cmd = {
      "Gen",
    },

    opts = function(_, opts)
      opts.model = "llama3.2:3b"
      opts.prompts = require("gen").prompts
      opts.prompts['Elaborate_Text'] = {
        prompt = "Elaborate the following text:\n$text",
        replace = true
      }
      opts.prompts['Fix_Code'] = {
        prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```"
      }
      return opts
    end,
  }
}
