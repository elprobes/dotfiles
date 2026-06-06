return {
    {
        "neovim/nvim-lspconfig",

        config = function()

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },

                        diagnostics = {
                            globals = { "vim" },
                        },

                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },

                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            vim.lsp.enable("lua_ls")
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("bashls")
            vim.lsp.enable("pylsp")
            vim.lsp.enable("yamlls")
            vim.lsp.enable("dockerls")
            vim.lsp.enable("html")
            vim.lsp.enable("cssls")
            vim.lsp.enable("jsonls")
        end,
    },
}
