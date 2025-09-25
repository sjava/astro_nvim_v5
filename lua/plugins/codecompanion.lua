return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup {
      adapters = {
        http = {
          qwen3 = function()
            return require("codecompanion.adapters").extend("openai", {
              name = "qwen3",
              url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
              env = {
                api_key = os.getenv "QWEN_API_KEY", -- 你设置在环境变量里的 key
              },
              schema = {
                model = {
                  default = "qwen3-max", -- 具体模型名称
                },
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = "qwen3",
        },
        inline = {
          adapter = "qwen3",
        },
        cmd = {
          adapter = "qwen3",
        },
      },
    }
  end,
}
