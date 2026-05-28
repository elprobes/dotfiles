return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "javascript",
          "typescript",
          "vue",
          "python",
          "bash",
          "html",
          "css",
          "json",
        },

        highlight = {
          enable = true,
        },

        indent = {
          enable = true,
        },
      })
    end,
  },
}
