return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },

            sh = { "shfmt" },
			bash = { "shfmt" },

			javascript = { "prettier" },
			typescript = { "prettier" },

			vue = { "prettier" },

			html = { "prettier" },
			css = { "prettier" },

			json = { "prettier" },

			yaml = { "prettier" },

			markdown = { "prettier" },
		},

		--format_on_save = {
		--	timeout_ms = 500,
		--	lsp_fallback = true,
		--},
	},
}
