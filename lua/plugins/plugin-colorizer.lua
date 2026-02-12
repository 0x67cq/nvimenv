return {
	{
		"norcalli/nvim-colorizer.lua",
		-- [优化] 懒加载：打开文件时才加载
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("configs.editor.colorizer")
		end,
	},
}
