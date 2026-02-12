--[[ 🟢 场景 A：代码写炸了，看看哪里错了
* 操作: 按 <leader>xx。
* 效果: 底部弹出一个窗口，列出整个项目里所有的 Error 和 Warning。
* 动作: 按 j/k 选择，按 Enter 跳转过去修 bug。修完一个，列表会自动刷新，直到清空所有 Bug。
🟢 场景 B：这函数在哪里被调用过？ (LSP References)
* 痛点: Telescope 找引用虽然好，但如果你想一边看代码一边对照引用列表，Telescope 的浮窗就挡视线了。
* 操作: 光标移到函数名上，按 <leader>gr。
* 效果: Trouble 列表会显示所有调用这个函数的地方。你可以按 P 打开预览，按 j/k 快速浏览每一处调用，体验极佳。
🟢 场景 C：专注当前文件
* 操作: 按 <leader>xd。
* 效果: 过滤掉其他文件的干扰，只看当前 Buffer 的问题。 ]]

return {
	{
		"folke/trouble.nvim",
		-- [优化] 只有按下快捷键或执行命令时才加载
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
			-- [神器] 找引用：配合 gopls/clangd 极好用
			{ "<leader>gr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP References" },
		},
		config = function()
			require("configs.coding.trouble")
		end,
	},
}
