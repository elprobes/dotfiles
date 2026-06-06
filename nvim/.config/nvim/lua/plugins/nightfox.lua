return {
    {
        "EdenEast/nightfox.nvim",

        priority = 1000,

        config = function()
            require("nightfox").setup({
                palettes = {
                    nightfox = {
                        bg0 = "#121923",
                        bg1 = "#121923",
                    },
                },
                options = {
                    transparent = false,
                }
            })

            vim.cmd.colorscheme("nightfox")
        end,
    },
}
