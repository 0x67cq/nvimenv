return {
	{
		"numToStr/Comment.nvim",
		-- [优化] 懒加载：打开文件时加载
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			-- [必须] 只有依赖这个，才能在 Svelte/Vue 中自动切换 // 和 "JoosepAlviste/nvim-ts-context-commentstring",
			"nvim-ts-context-commentstring",
		},
		-- [修正] init 改为 config，确保插件加载后再执行配置
		config = function()
			require("configs.coding.comment")
		end,
	},
}
