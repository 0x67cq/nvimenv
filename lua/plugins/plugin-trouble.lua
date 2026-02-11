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
