--[[ 🟢 场景 A：代码导航 (阅读代码)
你正在看一个巨大的 C 或 Go 项目，想知道这个函数是在哪定义的。
    gd (Go to Definition): 跳转到定义。
        例子: 光标放在 fmt.Println 上按 gd，会跳到 Go 源码。
    gr (Go to References): 查看引用。
        例子: 光标放在 MyFunction 上按 gr，弹出一个列表，显示所有调用这个函数的地方。
    gD (Declaration): 跳转到声明 (C/C++常用，头文件)。
    K (Hover): 查看文档。
        例子: 光标放在 http.ListenAndServe 上按 K，显示函数签名和文档注释。
🟢 场景 B：重构 (修改代码)
你想把一个变量名 idx 改成 index，但文件里有 100 个 idx，你不想手动改。
    <Leader>rn (Rename): 智能重命名。
        它不仅改当前文件，还会改整个项目里引用了这个变量的地方。比全局替换安全 100 倍。
🟢 场景 C：智能修复 (Code Action)
LSP 发现你有一个错误，或者有一个可以优化的地方。
    <Leader>ca (Code Action): 代码行为。
        例子 1 (Go): 你写了 type MyStruct struct 还没填字段，LSP 提示 "Fill struct"，按 ca 自动填满字段。
        例子 2 (Svelte/JS): 你用了 import ... 但没安装包，或者拼写错误，按 ca 可能会提示 "Fix import"。
🟢 场景 D：诊断跳转 (找错)
文件里有红色的波浪线报错。
    [d: 跳转到上一个错误。
    ]d: 跳转到下一个错误。
    <Leader>q: 打开诊断列表 (Diagnostics List)，统一看所有错误。
]]

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
