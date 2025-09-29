return {
  "Saghen/blink.cmp",
  opts = {
    signature = { enabled = true },
    sources = {
      providers = {
        buffer = {
          opts = {
            -- filter to only "normal" buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buftype == "" end, vim.api.nvim_list_bufs())
            end,
          },
        },
        path = {
          enabled = function() return vim.bo.filetype ~= "copilot-chat" end,
        },
      },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
  },
  specs = {
    "mikavilpas/blink-ripgrep.nvim",
    specs = {
      "Saghen/blink.cmp",
      opts = function(_, opts)
        table.insert(opts.sources.default, "ripgrep")
        return require("astrocore").extend_tbl(opts, {
          sources = {
            providers = {
              ripgrep = {
                module = "blink-ripgrep",
                name = "Ripgrep",
                -- the options below are optional, some default values are shown
                ---@module "blink-ripgrep"
                ---@type blink-ripgrep.Options
                opts = {
                  backend = {
                    use = "gitgrep-or-ripgrep",
                  },
                  debug = false,
                },
                transform_items = function(_, items)
                  for _, item in ipairs(items) do
                    item.labelDetails = {
                      description = "(rg)",
                    }
                  end
                  return items
                end,
              },
            },
          },
        })
      end,
    },
  },
}
