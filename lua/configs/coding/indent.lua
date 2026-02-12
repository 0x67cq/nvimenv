local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
	return
end

ibl.setup({
	-- 1. 基础缩进线字符
	indent = {
		char = "│", -- 推荐字符: │ ┊ ┆
		tab_char = "│",
	},

	-- 2. 作用域 (Scope) 高亮
	-- 这就是以前的 show_current_context，现在独立出来了
	scope = {
		enabled = true, -- 开启高亮当前代码块的缩进线
		show_start = false, -- 不显示代码块顶部的横线 (太乱)
		show_end = false, -- 不显示代码块底部的横线
	},

	-- 3. 排除规则 (在哪里不显示缩进线)
	exclude = {
		filetypes = {
			"help",
			"startify",
			"dashboard",
			"alpha",
			"packer",
			"neogitstatus",
			"NvimTree", -- 文件树
			"Trouble", -- 诊断列表
			"text", -- 纯文本
			"TelescopePrompt", -- 搜索框
			"mason", -- Mason 面板
			"lazy", -- Lazy 面板
		},
		buftypes = {
			"terminal",
			"nofile",
			"quickfix",
			"prompt",
		},
	},
})
