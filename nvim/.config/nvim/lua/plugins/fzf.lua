return {
    {
        "ibhagwan/fzf-lua",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("fzf-lua").setup({
                winopts = {
                    height = 0.85,
                    width = 0.80,
                    preview = {
                        layout = "vertical",
                    },
                },
            })
        end,
    },
}
