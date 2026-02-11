return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			-- [自定义设置]
			-- 你自定义的标签字符顺序 (优先使用中间行)
			labels = "asdfghjklqwertyuiopzxcvbnm",

			-- 搜索模式配置
			modes = {
				-- f/t 搜索增强
				char = {
					jump_labels = true, -- f/t 时显示标签
				},
				-- 普通搜索 /
				search = {
					enabled = true,
				},
			},

			-- 提示窗口配置
			prompt = {
				enabled = true,
				prefix = { { "⚡", "FlashPromptIcon" } },
			},
		},

		-- [快捷键配置]
		keys = {
			-- 核心跳转 (s)
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},

			-- Treesitter 语义选择 (S) - 选中整个函数/块
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},

			-- 远程操作 (r) - 比如 dr (删除远处的内容)
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},

			-- Treesitter 搜索范围 (R)
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},

			-- 切换 Flash 开关 (Leader s)
			{
				"<leader>s",
				mode = { "n", "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}
