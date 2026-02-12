--[[ 🟢 (Persistence)
    打开 Neovim 写代码。
    直接退出 :qa (插件自动静默保存)。
    下次进目录打开 Neovim。
    首页 Dashboard (Alpha) 上按 qs 或者 <leader>qs。
    结果：瞬间恢复上次打开的所有代码文件，且自动过滤掉 NvimTree 等干扰窗口，布局完美。
 ]]
return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- 打开文件时预加载
		opts = {
			-- 这里的配置通常默认即可，它会自动忽略 NvimTree 等窗口
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
			need = 1, -- 至少打开了一个文件才保存会话 (防止打开个空 nvim 也保存)
		},
		-- 快捷键配置
		keys = {
			-- [恢复当前目录的会话] (最常用)
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},

			-- [恢复上一次的会话] (不一定是当前目录)
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},

			-- [停止记录会话] (本次退出不保存)
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},
}
