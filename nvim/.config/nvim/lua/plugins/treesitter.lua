return {
    {
        "nvim-treesitter/nvim-treesitter",

        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter.config").setup({
                ensure_installed = {
                    "lua",
                    "vim",
                    "vimdoc",
                    "bash",
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                    "json",
                    "yaml",
                    "dockerfile",
                    "sql",
                    "markdown",
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
