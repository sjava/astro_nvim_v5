return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      adapters = {
        http = {
          qwen3 = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "qwen3",
              env = {
                api_key = os.getenv "QWEN_API_KEY",
                url = "https://dashscope.aliyuncs.com/compatible-mode",
                chat_url = "/v1/chat/completions",
                models_endpoint = "/v1/models",
              },
              schema = {
                model = {
                  default = "qwen3-max",
                },
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "qwen3",
          slash_commands = {
            ["symbols"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["buffer"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["file"] = {
              opts = {
                provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
              },
            },
            ["help"] = {
              opts = {
                provider = "snacks",
                max_lines = 1000,
              },
            },
          },
          keymaps = (function()
            local keymaps = vim.deepcopy(require("codecompanion.config").config.interactions.chat.keymaps)
            for _, keymap in pairs(keymaps) do
              if type(keymap.modes) == "string" then keymap.modes = { keymap.modes } end
              local new_modes = {}
              for mode, keys in pairs(keymap.modes or {}) do
                if type(keys) == "string" then
                  keys = { keys }
                elseif type(keys) ~= "table" then
                  keys = {}
                end
                for i, key in ipairs(keys) do
                  if type(key) == "string" and key:sub(1, 1) == "g" then keys[i] = "<localleader>" .. key:sub(2) end
                end
                new_modes[mode] = keys
              end
              keymap.modes = new_modes
            end
            return keymaps
          end)(),
        },
        inline = { adapter = "qwen3" },
        cmd = { adapter = "qwen3" },
      },
    })
  end,
}
