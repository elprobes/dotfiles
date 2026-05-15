return {
    {
        "lewis6991/gitsigns.nvim",

        config = function()
            require("gitsigns").setup()

            vim.keymap.set("n", "]h", function()
                require("gitsigns").next_hunk()
            end)

            vim.keymap.set("n", "[h", function()
                require("gitsigns").prev_hunk()
            end)

            vim.keymap.set("n", "<leader>hp", function()
                require("gitsigns").preview_hunk()
            end)

            vim.keymap.set("n", "<leader>hb", function()
                require("gitsigns").blame_line()
            end)
        end
    }
}
