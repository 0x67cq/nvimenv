--[[ 🟢 场景 A：运行服务 (Go/Svelte)
* 操作: 按 Ctrl + \。
* 效果: 底部弹出一个小窗口。
* 动作: 输入 go run . 或 npm run dev。
* 优势: 再次按 Ctrl + \ 隐藏它，程序会在后台继续运行，不会中断。
🟢 场景 B：在终端里优雅跳转
* 痛点: 普通终端模式下，你想跳出终端去改代码，得按 Ctrl-\ Ctrl-n 退出插入模式，再按 Ctrl-w l 跳走。
* 现在: 直接在终端插入模式下按 Ctrl + k。
* 效果: 自动识别你是从终端出来的，直接跳到上面的代码窗口。
🟢 场景 C：沉浸式 Git (Lazygit)
* 前提: 电脑里安装了 lazygit 命令。
* 操作: 按 <leader>tg。
* 效果: 弹出一个巨大的、美观的 Git 管理浮窗。
* 用途: 比用命令行打 git add/commit 快无数倍。处理完后按 q 或快捷键关闭，立刻回到代码。
🟢 场景 D：多终端管理
* 操作: 在底部终端里，你可以开启多个任务。
* 技巧: 输入 :2ToggleTerm 可以开启第二个独立终端。
]]
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		-- [优化] 只有按下快捷键时才加载，省下几毫秒启动时间
		keys = { [[<C-\>]], "<leader>tg", "<leader>th" },
		config = function()
			require("configs.coding.toggleterm")
		end,
	},
}
