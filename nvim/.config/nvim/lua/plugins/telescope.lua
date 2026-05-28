return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",

		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},

		{
			"nvim-telescope/telescope-ui-select.nvim",
		},
	},

	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",

				layout_config = {
					width = 0.95,
					height = 0.90,

					horizontal = {
						preview_width = 0.6,
					},
				},

				path_display = {
					"smart",
				},

				sorting_strategy = "ascending",

				prompt_prefix = "   ",
				selection_caret = " ",

				file_ignore_patterns = {
					"node_modules",
					".git/",
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},

				["ui-select"] = require("telescope.themes").get_dropdown({}),
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
	end,
}
