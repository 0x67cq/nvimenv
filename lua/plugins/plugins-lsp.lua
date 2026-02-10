return {
	-- lsp config
	{
		"neovim/nvim-lspconfig",
		-- init = function() require("configs.coding.lspconfig") end,
	},
	{
		"williamboman/mason.nvim",
		-- init = function() require("configs.coding.mason").setup() end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		init = function()
			require("configs.coding.lsp").setup()
		end,
	},
	-- lsp server 自动化安装
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("configs.coding.none-ls").setup()
		end,
	},

	-- 函数参数浮框显示
	{
		"ray-x/lsp_signature.nvim",
		lazy = true,
		init = function()
			require("configs.coding.lsp-signature")
		end,
	},
}
