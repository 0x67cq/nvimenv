return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" }, -- 确保先加载 mason
		config = function()
			-- 这里引用具体的配置逻辑，或者直接写 setup
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier", -- 自动安装 prettier
					"delve", -- 自动安装 dlv
				},
			})
		end,
	},
}
