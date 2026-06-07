return {
    {
        "ibhagwan/fzf-lua",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("fzf-lua").setup({
                files = {
                    fd_opts = "--type f --hidden --follow --exclude .git",
                },

                grep = {
                    hidden = true,
                },

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
