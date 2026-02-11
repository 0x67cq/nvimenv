return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		-- [修复] 必须用 config，确保插件加载后再运行配置
		config = function()
			require("configs.editor.bufferline")
		end,
	},
}
