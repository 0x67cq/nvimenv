return {
	-- [1] 核心引擎 (负责解析和高亮)
	{
		"nvim-treesitter/nvim-treesitter",
		-- [优化] 懒加载：打开文件时才加载，加快启动速度
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			-- [神器] 自动闭合 HTML/Svelte 标签 (输入 <div> 自动补 </div>)
			"windwp/nvim-ts-autotag",
			-- 智能注释 (Svelte 必备)
			-- [修复] 独立配置 context-commentstring
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				init = function()
					-- 1. 告诉 Treesitter 不要加载旧模块，防止报错
					vim.g.skip_ts_context_commentstring_module = true
				end,
				config = function()
					-- 2. 独立启动该插件
					require("ts_context_commentstring").setup({
						enable_autocmd = false,
					})
				end,
			},
		},
		config = function()
			-- 将配置放在 config 中，确保插件加载后才执行 setup
			require("configs.coding.treesitter")
		end,
	},

	-- [2] 函数上下文 (Sticky Scroll)
	-- 当你滚动长代码时，函数名会吸附在顶部，让你知道自己在哪个函数里
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			enable = true,
			max_lines = 3, -- 最多吸附 3 行，防止挡住视线
			trim_scope = "outer",
			mode = "cursor",
		},
	},

	-- [3] Playground (已废弃，建议移除)
	-- 如果你非常喜欢旧版的 playground 界面，可以保留。
	-- 但推荐使用 Neovim 原生的 :InspectTree 命令。
	-- { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
}
