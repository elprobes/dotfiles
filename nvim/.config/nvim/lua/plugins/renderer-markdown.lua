return {
	"MeanderingProgrammer/render-markdown.nvim",

	ft = { "markdown" },

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	opts = {
		latex = {
			enabled = false,
		},

		yaml = {
			enabled = false,
		},

		heading = {
			sign = false,
			width = "block",
		},

		code = {
			border = "rounded",
			width = "block",
			left_pad = 4,
			right_pad = 4,
		},

		bullet = {
			enabled = true,
		},
	},

	config = function(_, opts)
		require("render-markdown").setup(opts)

		-- Rimuove gli sfondi aggressivi degli heading
		vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "NONE" })

		-- Heading più sobri
		vim.api.nvim_set_hl(0, "RenderMarkdownH1", {
			fg = "#c0a060",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "RenderMarkdownH2", {
			fg = "#7fa05f",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "RenderMarkdownH3", {
			fg = "#6a85c5",
		})

		-- Codice tipo "pannello"
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", {
			bg = "#1f2335",
			fg = "#7fa05f",
		})

		vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", {
			bg = "#1f2335",
			fg = "#414868",
		})

		vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo", {
			fg = "#7aa2f7",
			italic = true,
		})
	end,
}
