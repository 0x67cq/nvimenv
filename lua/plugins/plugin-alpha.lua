return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter", -- 启动进入 Vim 时加载
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.editor.alpha")
		end,
	},
}
