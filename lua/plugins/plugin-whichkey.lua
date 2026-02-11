return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		-- [注意] v3.0 版本的配置逻辑有了很大变化
		config = function()
			require("configs.editor.whichkey")
		end,
	},
}
