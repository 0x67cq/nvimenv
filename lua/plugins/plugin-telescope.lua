--[[ 🟢 场景 A：文件导航 (肌肉记忆)
* 找文件: <leader>ff
    * 场景: 知道文件名，模糊匹配。比如找 configs/editor/telescope.lua，只需输 tele 或 coedte。
    * 样式: 下拉框模式 (Dropdown)。
* 找最近文件: <leader>fo (Old files)
    * 场景: 早上刚开机，想继续昨晚没写完的文件。
* 找 Buffer: <leader>fb
    * 场景: 打开了十几个文件，想切回刚才那个。
🟢 场景 B：全项目内容搜索 (大杀器)
* 全局搜词: <leader>fw (Word)
    * 场景: 记得写过 function M.setup，但不记得在哪个文件了。
    * 操作: 输入 setup，右侧会实时预览文件内容。
* 搜光标下的词: <leader>fg (Grep cursor)
    * 场景: 看到代码里调用了一个函数 DoSomething()，想看看它在哪定义的，或者哪里还用到了它。
    * 操作: 光标移到函数名上，按 <leader>fg。
🟢 场景 C：多项目切换 (Project Manager)
这是你配置里的 project 扩展功能。
* 切换项目: <leader>pm
    * 会列出 ~/syncnote 下的所有文件夹。
    * 选中一个回车，Neovim 会自动切换工作目录（Root Directory），并且同步 NvimTree。
* 项目管理操作 (在 <leader>pm 弹窗内):
    * c: Create project (新建项目)。
    * d: Delete project (从列表移除，不删文件)。
    * r: Rename project。
    * w: 只切换目录，不打开文件查找。
🟢 场景 D：窗口内操作 (不用鼠标)
当 Telescope 弹窗打开时：
* 上下移动: Ctrl + n (下), Ctrl + p (上)。
* 查看历史: Ctrl + j / k (比如你刚才搜过 "main"，想再搜一次，按一下就出来了)。
* 预览滚动: Ctrl + u (上), Ctrl + d (下) —— 当预览文件很长时很有用。
* 打开方式:
    * Enter: 当前窗口打开。
    * Ctrl + v: 垂直分屏打开。
    * Ctrl + x: 水平分屏打开。 ]]

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8", -- 锁定版本，防止更新挂掉
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				-- FZF 模糊搜索算法 (C语言编译，速度极快)
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-tree/nvim-web-devicons", -- 图标支持
			"nvim-telescope/telescope-project.nvim",
		},
		-- [懒加载] 只有按下这些键时，Telescope 才会加载
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
		},
		config = function()
			require("configs.editor.telescope")
		end,
	},
}
