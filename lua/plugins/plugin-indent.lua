return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl", -- 指定入口模块，v3 版本必须
		event = { "BufReadPost", "BufNewFile" }, -- 打开文件时才显示缩进线
		config = function()
			require("configs.coding.indent")
		end,
	},
}
