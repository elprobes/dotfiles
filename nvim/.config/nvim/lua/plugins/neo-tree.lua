return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },

  config = function()
    require("neo-tree").setup({

      -- =====================================================
      -- WINDOW / KEYMAPS
      -- =====================================================

      window = {
        mappings = {

          -- navigation
          ["l"] = "open",
          ["h"] = "close_node",

          -- open
          ["<cr>"] = "open",

          -- splits
          ["s"] = "open_split",
          ["v"] = "open_vsplit",

          -- tabs
          ["t"] = "open_tabnew",

          -- preview
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = true,
            },
          },

          -- hidden files
          ["H"] = "toggle_hidden",
        },
      },

      -- =====================================================
      -- FILESYSTEM
      -- =====================================================

      filesystem = {

        -- segue automaticamente il file aperto
        follow_current_file = {
          enabled = true,
        },

        -- comportamento netrw
        hijack_netrw_behavior = "open_current",

        -- mostra file nascosti
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },

        -- evita cartelle collassate tipo a/b/c
        group_empty_dirs = false,
      },
    })

    -- =====================================================
    -- KEYMAP GLOBALE
    -- =====================================================

    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {
      desc = "Toggle Neo-tree",
    })
  end,
}
