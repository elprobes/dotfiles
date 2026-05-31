return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },

			sh = { "shfmt" },
			bash = { "shfmt" },

			c = { "clang_format" },
			cpp = { "clang_format" },

			javascript = { "prettier" },
			typescript = { "prettier" },

			vue = { "prettier" },

			html = { "prettier" },
			xhtml = { "prettier" },
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
