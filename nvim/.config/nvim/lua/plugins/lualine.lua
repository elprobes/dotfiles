return {
  {
    "nvim-lualine/lualine.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,

          component_separators = {
            left = "│",
            right = "│",
          },

          section_separators = {
            left = "",
            right = "",
          },

          theme = {
            normal = {
              a = { fg = "#1a1b26", bg = "#7aa2f7", gui = "bold" },
              b = { fg = "#c0caf5", bg = "#3b4261" },
              c = { fg = "#c0caf5", bg = "#24283b" },
            },

            insert = {
              a = { fg = "#1a1b26", bg = "#9ece6a", gui = "bold" },
              b = { fg = "#c0caf5", bg = "#3b4261" },
              c = { fg = "#c0caf5", bg = "#24283b" },
            },

            visual = {
              a = { fg = "#1a1b26", bg = "#bb9af7", gui = "bold" },
              b = { fg = "#c0caf5", bg = "#3b4261" },
              c = { fg = "#c0caf5", bg = "#24283b" },
            },

            replace = {
              a = { fg = "#1a1b26", bg = "#f7768e", gui = "bold" },
              b = { fg = "#c0caf5", bg = "#3b4261" },
              c = { fg = "#c0caf5", bg = "#24283b" },
            },

            command = {
              a = { fg = "#1a1b26", bg = "#e0af68", gui = "bold" },
              b = { fg = "#c0caf5", bg = "#3b4261" },
              c = { fg = "#c0caf5", bg = "#24283b" },
            },

            inactive = {
              a = { fg = "#565f89", bg = "#1f2335" },
              b = { fg = "#565f89", bg = "#1f2335" },
              c = { fg = "#565f89", bg = "#1f2335" },
            },
          },
        },

        sections = {
          lualine_a = {
            {
              "mode",
              icon = "",
            },
          },

          lualine_b = {
            {
              "branch",
              icon = "",
            },
          },

          lualine_c = {
            {
              "filename",
              path = 1,

              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = " [No Name]",
              },
            },
          },

          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰌵 ",
              },
            },
          },

          lualine_y = {
            {
              "filetype",
              icon_only = false,
            },
          },

          lualine_z = {
            {
              "location",
              icon = "󰍹",
            },
          },
        },
      })

      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
    end,
  },
}
