return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- [优化] 懒加载：只有输入命令或按键时才加载
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
		keys = {
			-- 这里配置快捷键，Lazy 会自动建立映射
			-- 当你按 <leader>e 时，插件才会被加载并执行 toggle
			{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
		},
		config = function()
			require("configs.editor.nvim-tree")
		end,
	},
}
