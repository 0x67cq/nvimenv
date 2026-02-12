--[[ 打开界面: 输入 :DBUI。
添加连接:
    界面左侧会打开侧边栏。
    按 A (Add) 添加新连接。
    输入连接串，例如：mysql://root:password@localhost:3306/my_db。
写 SQL:
    在侧边栏选中表，按 Enter。
    新建一个 .sql 文件。
    输入 SELECT * FROM us... -> 此时会自动弹出 users 表的补全！
执行查询:
    选中 SQL 语句 (Visual 模式)。
    按 <leader>W (默认保存即执行) 或自定义快捷键。 ]]

return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" }, -- 仅在 SQL 文件加载补全插件
				lazy = true,
			},
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		-- [关键] 必须在 init 里配置全局变量，确保 UI 加载时能读到配置
		init = function()
			-- 1. 界面设置
			vim.g.db_ui_use_nerd_fonts = 1 -- 开启图标
			vim.g.db_ui_show_database_icon = 1

			-- 2. 布局设置
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_winwidth = 30

			-- 3. 保存路径 (建议存在数据目录，而不是配置目录)
			-- 这样你的数据库连接信息不会污染你的 git 仓库
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

			-- 4. 自动补全设置 (关联 cmp)
			-- 当进入 SQL 文件时，自动把 db 补全源加入 cmp
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					local cmp = require("cmp")
					cmp.setup.buffer({
						sources = {
							{ name = "vim-dadbod-completion" }, -- DB 补全优先
							{ name = "buffer" },
						},
					})
				end,
			})
		end,
	},
}
