return {
	-- [1] Mason: 负责下载 (必须最先加载)
	{
		"williamboman/mason.nvim",
		-- 懒加载：只有打开文件时才加载，提升启动速度
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- 如果你有装这个
		},
		config = function()
			-- 这里的 setup 对应我们之前修改过的 lua/configs/coding/mason.lua
			require("configs.coding.mason").setup()
		end,
	},

	-- [2] LSP Config: 核心配置 (依赖 Mason)
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp", -- LSP 补全能力
			{ "j-hui/fidget.nvim", opts = {} }, -- [推荐] 右下角显示 "LSP Loading..." 进度条
		},
		config = function()
			-- 这里将是下一份我们要配置的核心文件
			require("configs.coding.lsp")
		end,
	},

	-- [3] None-LS: 格式化与补充工具 (Prettier, GoImports)
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.coding.none-ls").setup()
		end,
	},

	-- [4] 参数提示 (输入函数参数时弹出浮窗)
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter", -- 插入模式才需要
		config = function()
			require("lsp_signature").setup({
				bind = true,
				handler_opts = {
					border = "rounded",
				},
				hint_enable = false, -- 0.10+ 如果觉得吵可以关掉这个虚拟文本提示
			})
		end,
	},
}
