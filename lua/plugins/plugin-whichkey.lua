--[[ 🟢 场景 A：忘记 Telescope 命令了
1. 按下 Space (空格)。
2. 等待 0.3 秒。
3. 底部弹出菜单，你看到 f 对应 Find。
4. 按下 f。
5. 菜单进入下一级，显示：
    * f: Find Files
    * g: Live Grep
    * b: Buffers
    * h: Help Tags
6. 这时候你记起来了：“哦，我要找文件，按 f”。
🟢 场景 B：探索 Git 功能
1. 按下 Space -> g (Git)。
2. 你会看到我们之前配置的所有 Git 功能：
    * m: Git Commits
    * s: Git Status
    * h: Hunk Actions + (这是一个子菜单)
3. 按下 h。
4. 你会看到 Gitsigns 的所有操作：
    * p: Preview Hunk
    * r: Reset Hunk
    * b: Blame Line
🟢 场景 C：查看按键冲突
WhichKey 还有一个隐形的好处：如果某个按键你在两个插件里都定义了，WhichKey 会在菜单里显示出来（或者报错），帮你快速发现按键冲突。 ]]

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			-- [关键] 设置超时时间
			-- 如果不设置这个，按下空格键后要等 1秒(默认) 才会弹出菜单
			-- 设置为 300ms 既不会干扰快速输入，又能及时显示提示
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		config = function()
			require("configs.editor.whichkey")
		end,
	},
}
