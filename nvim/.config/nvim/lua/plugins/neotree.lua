return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },

        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,

                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    follow_current_file = {
                        enabled = true,
                    },

                    hijack_netrw_behavior = "open_current",
                },

                window = {
                    width = 30,
                },
            })
        end,
    },
}
