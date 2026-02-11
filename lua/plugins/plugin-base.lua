return {
	-- [1] Lua 工具库 (万物之源)
	{
		"nvim-lua/plenary.nvim",
		lazy = true, -- 懒加载：只有当其他插件需要它时才加载
	},

	-- [2] 图标库 (UI 的灵魂)
	-- 几乎所有界面插件(lualine, nvim-tree, bufferline)都依赖它来显示文件图标
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	-- [3] UI 组件库 (现代化插件依赖)
	-- 如果你以后想用 Noice.nvim (绚丽的消息通知) 或者 Neo-tree，这个是必须的
	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach", -- 当 LSP 启动时加载
		opts = {
			-- 这里通常用默认配置就很好看了
			notification = {
				window = {
					winblend = 0, -- 背景不透明度 (0-100)
				},
			},
		},
	},
}
