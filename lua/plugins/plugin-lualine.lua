return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy", -- 界面加载完成后再加载状态栏
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.editor.lualine")
		end,
	},
}
