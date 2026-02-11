return {
	{
		"sainnhe/gruvbox-material",
		lazy = false, -- 必须立即加载
		priority = 1000, -- 优先级最高
		config = function()
			-- [配置项] 必须在 colorscheme 命令之前设置

			-- 1. 开启透明背景 (配合你的透明终端使用)
			-- 如果你之前用了 transparent.nvim 插件，开启这个后可能就不需要那个插件了
			-- vim.g.gruvbox_material_transparent_background = 1

			-- 2. 设置背景对比度 (soft, medium, hard)
			-- 'hard' 对比度最高，代码最清晰；'soft' 更护眼
			vim.g.gruvbox_material_background = "hard"

			-- 3. 启用斜体 (注释使用斜体，非常有质感)
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1

			-- 4. 更好的诊断信息高亮 (让错误波浪线更清晰)
			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

			-- [加载主题]
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
}
