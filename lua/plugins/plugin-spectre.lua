return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("spectre").setup({
			is_insert_mode = false, -- 进入时默认非编辑模式
			live_update = true, -- 实时更新预览
			highlight = {
				ui = "String",
				search = "DiffDelete", -- 使用差分高亮
				replace = "DiffAdd",
			},
		})
	end,
	keys = {
		-- 快捷键：全局打开 Spectre
		{ "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre" },
		-- 快捷键：搜索当前光标下的单词
		{
			"<leader>sw",
			'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
			desc = "Search current word",
		},
	},
}
