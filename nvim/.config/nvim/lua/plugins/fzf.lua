return {
    {
        "ibhagwan/fzf-lua",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            fzf_opts = {
                ["--exact"] = "",
            },

            files = {
                hidden = true,

                fd_opts = [[
                    --type f
                    --hidden
                    --follow
                    --exclude .git
                    --exclude node_modules
                    --exclude dist
                    --exclude target
                    --exclude .cache
                ]],
            },
        },
    },
}
