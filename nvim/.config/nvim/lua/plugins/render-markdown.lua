return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.nvim",
        },
        opts = {
            heading = {
                width = "block",
                left_pad = 2,
                right_pad = 2,
            },
            code = {
                language_name = true,
                langua_icon = true,
                language_pad = 1,
                width = "block",
                left_pad = 2,
                right_pad = 2,
                left_margin = 2,
                border = "thin",
            }
        },
    },
}
