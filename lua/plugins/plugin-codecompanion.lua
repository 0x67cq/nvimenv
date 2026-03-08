return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		"ravitemer/codecompanion-history.nvim",
	},
	keys = {
		-- 核心面板
		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI 动作菜单 (Actions)" },
		{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI 对话框 (Chat)" },

		-- 本地小范围生成 (Inline)
		{ "<leader>ai", "<cmd>CodeCompanion<cr>", mode = "n", desc = "AI 行内指令 (Inline)" },

		-- 自定义的一键快捷指令 (直接调用本地 Qwen 3.5)
		{ "<leader>am", "<cmd>CodeCompanion /AddComments<cr>", mode = "v", desc = "AI 翻译/加注释 (本地)" },
		{ "<leader>at", "<cmd>CodeCompanion /WriteTests<cr>", mode = "v", desc = "AI 生成测试 (本地)" },
		{ "<leader>ah", "<cmd>Telescope codecompanion<cr>", mode = "n", desc = "AI 历史记录 (History)" },
	},
	config = function()
		require("configs.coding.codecompanion")
	end,
}
