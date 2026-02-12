return {
	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("configs.editor.scrollbar")
		end,
	},
}
