local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

wk.setup({
	-- [外观设置]
	ui = {
		border = "rounded", -- 圆角边框，适配你的 UI 风格
	},

	-- [图标设置]
	icons = {
		breadcrumb = "»", -- 面包屑导航符号
		separator = "➜", -- 键位与描述的分隔符
		group = "+", -- 组名前缀
	},

	-- [核心] 定义按键组名称
	-- 这里不需要定义具体的快捷键功能(功能在各插件里定义好了)
	-- 这里只需要告诉 WhichKey："<leader>f" 开头的这组按键叫 "Find"
	spec = {
		mode = { "n", "v" }, -- 在普通模式和 Visual 模式下生效

		-- 常用单键
		{ "<leader>q", desc = "Quit" },
		{ "<leader>w", desc = "Save" },
		{ "<leader>e", desc = "Explorer" }, -- NvimTree
		{ "<leader>c", desc = "Comment" }, -- Comment

		-- 分组定义
		{ "<leader>f", group = "Find (Telescope)" }, -- 对应 plugin-telescope
		{ "<leader>g", group = "Git" }, -- 对应 gitsigns / lazygit
		{ "<leader>gh", group = "Hunk Actions" }, -- gitsigns 的子菜单
		{ "<leader>b", group = "Buffers" }, -- 对应 bufferline
		{ "<leader>l", group = "LSP" }, -- 对应 lsp
		{ "<leader>t", group = "Terminal" }, -- 对应 toggleterm
		{ "<leader>p", group = "Project" }, -- 对应 telescope-project
		{ "<leader>d", group = "Debug" }, -- 对应 dap (即将配置)

		-- [代码折叠] (可选，配合 ufo 或原生折叠)
		-- { "<leader>z", group = "Fold" },
	},
})
