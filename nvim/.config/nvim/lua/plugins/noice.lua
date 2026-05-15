return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",

      {
        "rcarriga/nvim-notify",
        config = function()
          require("notify").setup({
            background_colour = "#1f2335",
          })

          vim.notify = require("notify")
        end,
      },
    },

    opts = {
      cmdline = {
        view = "cmdline_popup",

        format = {
          cmdline = {
            pattern = "^:",
            icon = "",
            lang = "vim",
            title = "",
          },

          search_down = {
            pattern = "^/",
            icon = "󰱼",
            lang = "regex",
            title = "",
          },

          search_up = {
            pattern = "^%?",
            icon = "󰜮",
            lang = "regex",
            title = "",
          },
        },
      },

      views = {
        cmdline_popup = {
          position = {
            row = "25%",
            col = "0%",
          },

          size = {
            width = 60,
            height = "auto",
          },

          border = {
            style = "none",

            padding = {
              1,
              2,
            },
          },

          win_options = {
            winblend = 0,

            winhighlight = {
              Normal = "NoiceCmdlinePopup",
            },
          },
        },
      },

      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },

    config = function(_, opts)
      require("noice").setup(opts)

      vim.api.nvim_set_hl(0, "NormalFloat", {
        fg = "#c0caf5",
        bg = "#1f2e35",
      })
      
      vim.api.nvim_set_hl(0, "FloatBorder", {
        bg = "#1f2e35",
      })

      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", {
        fg = "#c0caf5",
        bg = "#1f2335",
      })

      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", {
        fg = "#7aa2f7",
        bg = "#1f2335",
        bold = true,
      })

      vim.api.nvim_set_hl(0, "NotifyBackground", {
        bg = "#1f2335",
      })

      vim.api.nvim_set_hl(0, "NoicePopup", {
        fg = "#c0caf5",
        bg = "#1f2e35",
      })

      vim.api.nvim_set_hl(0, "NoicePopupmenu", {
        fg = "#c0caf5",
        bg = "#1f2e35",
      })
    end,
  },
}
