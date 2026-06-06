return {
    {
        "stevearc/conform.nvim",

        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },

                    javascript = { "prettier" },
                    javascriptreact = { "prettier" },

                    typescript = { "prettier" },
                    typescriptreact = { "prettier" },

                    html = { "prettier" },
                    css = { "prettier" },

                    json = { "prettier" },
                    yaml = { "prettier" },

                    markdown = { "prettier" },

                    bash = { "shfmt" },
                },
            })
        end,
    },
}
