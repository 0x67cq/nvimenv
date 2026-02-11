local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	-- 1. 确保安装列表 (补全了 Go 和 Lua 的生态)
	ensure_installed = {
		"c",
		"lua",
		"luadoc",
		"luap", -- Lua 全家桶
		"vim",
		"vimdoc",
		"query",
		"bash",
		"go",
		"gomod",
		"gowork",
		"gosum", -- Go 全家桶
		"rust",
		"python",
		"svelte", -- Svelte
		"javascript",
		"typescript",
		"tsx",
		"html",
		"css",
		"json",
		"yaml",
		"markdown",
		"markdown_inline", -- 现在的 Help 文档和 Readme 都是 markdown
	},

	-- 2. 异步安装 (不要卡住界面)
	sync_install = false,

	-- 3. 自动安装缺失的 Parser
	auto_install = true,

	-- 4. 忽略安装 (如果有的文件太大导致死机)
	ignore_install = {},

	-- 5. 高亮模块
	highlight = {
		enable = true, -- 必须开启
		disable = function(lang, buf)
			-- 如果文件超过 100KB，禁用高亮以防卡顿
			local max_filesize = 100 * 1024
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = false,
	},

	-- 6. 智能缩进 (= 号后的换行缩进)
	indent = {
		enable = true,
	},

	-- 7. 自动标签闭合 (需要 nvim-ts-autotag 插件)
	-- 输入 <div> 自动变 <div></div>
	autotag = {
		enable = true,
	},

	-- 8. 增量选择 (你的配置很好，保持原样)
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>", -- 回车开始选中
			node_incremental = "<CR>", -- 回车扩大选中
			scope_incremental = "<TAB>", -- Tab 选中整个函数/块
			node_decremental = "<BS>", -- 退格缩小选中
		},
	},
})

-- =============================================================================
-- 折叠设置 (基于 Treesitter 的代码折叠)
-- =============================================================================
-- 这会让你的代码像 VSCode 一样可以折叠函数和 if 块
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- 默认不折叠，打开文件时全部展开
vim.opt.foldlevel = 99
