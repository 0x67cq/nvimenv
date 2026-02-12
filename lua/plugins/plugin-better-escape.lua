return {
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter", -- 进入插入模式时才加载
		config = function()
			require("configs.editor.better_escape")
		end,
	},
}
