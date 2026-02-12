local status_ok, scrollbar = pcall(require, "scrollbar")
if not status_ok then
	return
end

-- 颜色配置 (适配你的 Gruvbox 风格)
-- 如果不设置，它会尝试自动提取，但有时不准
local colors = {
	bg = "#282828",
	handle = "#504945",
	search = "#d79921", -- 黄色
	error = "#cc241d", -- 红色
	warn = "#d65d0e", -- 橙色
	info = "#458588", -- 蓝色
	hint = "#689d6a", -- 绿色
	git_add = "#b8bb26",
	git_change = "#83a598",
	git_del = "#fb4934",
}

scrollbar.setup({
	show = true,
	show_in_active_only = false,
	set_highlights = true,
	folds = 1000, -- 处理折叠代码的滚动条
	max_lines = false,

	-- [外观] 滚动条把手
	handle = {
		text = " ",
		blend = 50, -- 透明度 (0-100)，适配透明背景
		color = colors.handle,
		highlight = "CursorColumn",
		hide_if_all_visible = true, -- [贴心] 如果文件一页能显示完，就不显示滚动条
	},

	-- [核心] 标记点颜色
	marks = {
		Search = { color = colors.search },
		Error = { color = colors.error },
		Warn = { color = colors.warn },
		Info = { color = colors.info },
		Hint = { color = colors.hint },
		Misc = { color = "purple" },
		GitAdd = { color = colors.git_add },
		GitChange = { color = colors.git_change },
		GitDelete = { color = colors.git_del },
	},

	-- [核心] 集成功能开关
	handlers = {
		cursor = false, -- 光标位置 (可选开)
		diagnostic = true, -- [重要] 显示 LSP 报错位置
		gitsigns = true, -- [重要] 显示 Git 修改位置 (需要 gitsigns 插件)
		handle = true, -- 显示滚动滑块
		search = true, -- [重要] 显示搜索结果 (按 / 搜索时非常有用)
		ale = false, -- 不用 ale
	},

	-- 排除不需要滚动条的窗口
	excluded_filetypes = {
		"cmp_menu",
		"cmp_docs",
		"notify",
		"noice",
		"TelescopePrompt",
		"alpha",
		"NvimTree",
		"dashboard",
		"lazy",
		"mason",
		"toggleterm",
	},
})
