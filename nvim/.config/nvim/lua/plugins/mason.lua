return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"mason-org/mason-lspconfig.nvim",

		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},

		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"vue_ls",
				"pyright",
				"bashls",
				"html",
				"cssls",
				"jsonls",
			},
		},

		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				ts_ls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
					},

					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
								languages = { "vue" },
							},
						},
					},
				},
				vue_ls = {},

				pyright = {},
				bashls = {},
				html = {},
				cssls = {},
				jsonls = {},
			}

			for server, server_opts in pairs(servers) do
				server_opts.capabilities = capabilities

				vim.lsp.config(server, server_opts)
				vim.lsp.enable(server)
			end
		end,
	},
}
