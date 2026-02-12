return {
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle", -- 也可以通过命令触发
		keys = {
			{ "<leader>ud", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
		},
		config = function()
			require("configs.editor.undotree")
		end,
	},
}
