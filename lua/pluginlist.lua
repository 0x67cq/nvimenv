-- 实现部分插件延后载入 主要由 event 和 cmd 实现
-- use { ‘xxx’, setup=”require(‘xxx’).setup()”, config=”require(‘xxx’).config()” } – setup发生在载入插件前 config发生在载入插件后
-- Packer.nvim hints
--     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
--     config = string or function,      -- Specifies code to run after this plugin is loaded
--     requires = string or list,        -- Specifies plugin dependencies. See "dependencies".
--     ft = string or list,              -- Specifies filetypes which load this plugin.
--     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin
local plugins = {
	-- plugins manager
	{ "wbthomason/packer.nvim" },

	----------------------------------------------------
	-- NOTE: PUT ABOUT ==EDITOR== THIRD PLUGIN HERE ----
	----------------------------------------------------
	-- colorscheme
	{ "sainnhe/gruvbox-material" },

	-- filebuf&pane-layout&tab save&recover
	{
		"tpope/vim-obsession",
		-- :Obsess 记录当前nvim布局, 记录到当前目录的session.vim
		-- :source *.vim 回复该session.vim的布局
	},

	-- layout change
	-- icon
	{ "kyazdani42/nvim-web-devicons" },
	-- 下边缘状态栏
	{
		"nvim-lualine/lualine.nvim",
		after = "nvim-web-devicons",
		setup = function()
			require("plugins.editor.lualine")
		end,
	},

	-- 上边缘tab页(可以再找找看)
	{
		"akinsho/bufferline.nvim",
		event = "BufRead",
		setup = function()
			require("plugins.editor.bufferline")
		end,
		-- require("plugins.bufferline.keymaps").map()
	},
	-- start screen
	{
		"goolord/alpha-nvim",
		config = function()
			require("plugins.editor.alpha")
		end,
	},
	-- RGB显色
	--{
	--	"norcalli/nvim-colorizer.lua",
	--	event = "BufRead",
	--	config = function()
	--		require("colorizer").setup()
	--	end,
	--},

	-- 控制 jk->esc 连按速度
	{
		"jdhao/better-escape.vim",
		opt = true,
		event = "InsertEnter",
		config = function()
			vim.cmd("let g:better_escape_shortcut = 'jk'")
			-- set time interval to 200 ms
			vim.cmd("let g:better_escape_interval = 200")
		end,
	},
	-- 侧边栏文件树
	-- TODO 修改样式为中心弹窗，比左侧边栏美观 设置透明度
	--    {
	--		"kyazdani42/nvim-tree.lua",
	--		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	--		config = function()
	--			require("plugins.configs.nvim-tree")
	--		end,
	--		setup = function()
	--			require("core.keymaps").nvimtree_setup()
	--		end,
	--	},

	-- 滚动页面效果
	{
		"petertriho/nvim-scrollbar",
		event = "BufRead",
		config = function()
			require("scrollbar").setup()
		end,
	},

	{
		"mbbill/undotree",
		setup = function()
			-- require("core.keymaps").undotree_setup()
		end,
	},

	-- Navigation
	{
		"phaazon/hop.nvim",
		cmd = {
			"HopLine",
			"HopLineStart",
			"HopWord",
			"HopPattern",
			"HopChar1",
			"HopChar2",
		},
		-- require("core.keymaps").hop_setup()
		setup = function()
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},

	-- 模糊查找
	{
		"nvim-telescope/telescope.nvim",
		setup = function()
			require("plugins.editor.telescope")
		end,
		-- require("core.keymaps").telescope_setup()
	},
	-- 接入fzf搜索工具
	--{
	--	"nvim-telescope/telescope-fzf-native.nvim",
	--	after = "telescope.nvim",
	--	-- event = "BufRead",
	--	run = "make",
	--	setup = function()
	--		-- vim.cmd([[packadd telescope-fzf-native.nvim]])
	--    require("telescope-fzf-native").setup()
	--	end,
	--},

	-- 项目管理&切换
	--	{
	--		"nvim-telescope/telescope-project.nvim",
	--		opt = true,
	--		event = "BufWinEnter",
	--		setup = function()
	--			-- vim.cmd([[packadd telescope-project.nvim]])
	--            require("telescope-project").setup()
	--		end,
	--	},

	----------------------------------------------------
	-- NOTE: PUT ABOUT ==CODING== THIRD PLUGIN HERE ----
	----------------------------------------------------
	-- 缩进线
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("plugins.coding.indentline")
		end,
	},

	-- git 相关操作
	{
		"lewis6991/gitsigns.nvim",
		setup = function()
			require("plugins.coding.gitsigns")
		end,
	},
	-- 自动闭合成对符号
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	-- 自动注释
	{
		"numToStr/Comment.nvim",
		setup = function()
			require("plugins.coding.comment")
		end,
		-- setup = function()
		-- require("core.keymaps").comment_setup()
		--end,
	},

	-- 抽象语法树渲染
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufRead", "BufNewFile" },
		run = ":TSUpdate",
		config = function()
			require("plugins.coding.treesitter")
		end,
		setup = function()
			-- require("core.keymaps").treesitter_setup()
		end,
	},

	-- 展示抽象语法树&直接修改显色值
	{ "nvim-treesitter/playground", after = "nvim-treesitter" },
	-- 函数声明行保留首行
	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
	},

	-- 符号表
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("plugins.coding.symbols-outline")
		end,
	},

	-- lsp config
	{
		"neovim/nvim-lspconfig",
		config = require("plugins.coding.lspconfig"),
	},
	{
		"williamboman/mason-lspconfig.nvim",
		after = "mason.nvim",
		setup = require("plugins.coding.mason-lspconfig").setup(),
	},
	-- lsp server 自动化安装
	{
		"williamboman/mason.nvim",
		config = require("plugins.coding.mason").setup(),
	},
	-- 函数参数浮框显示
	{
		"ray-x/lsp_signature.nvim",
		-- event = "BufRead",
		after = "nvim-lspconfig",
		config = function()
			require("plugins.coding.lsp_signature")
		end,
	},

	-- 美化补全弹窗
	{
		"onsails/lspkind.nvim",
	},
	-- 补全
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.coding.cmp")
		end,
	},
	-- TODO 找个时间去看一下 脚本这几个插件
	-- 加载脚本合集
	{
		"rafamadriz/friendly-snippets",
		event = "InsertEnter",
	},
	-- 脚本引擎
	{
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
		config = function()
			require("plugins.coding.lua_snip")
		end,
	},
	{
		"saadparwaiz1/cmp_luasnip",
		after = "LuaSnip",
	},
	{
		"hrsh7th/cmp-nvim-lua",
		after = "cmp_luasnip",
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		after = "cmp-nvim-lua",
		setup = function()
			vim.cmd([[packadd cmp-nvim-lsp]])
		end,
	},
	{
		"hrsh7th/cmp-cmdline",
		after = "nvim-cmp",
	},
	{
		"hrsh7th/cmp-buffer",
		after = "cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-path",
		after = "cmp-buffer",
	},

	-- 终端
	{
		"akinsho/toggleterm.nvim",
		setup = function()
			require("plugins.coding.toggleterm")
		end,
	},

	-- 断点调试 client & ui
	--{
	--	"mfussenegger/nvim-dap",
	--	opt = true,
	--	event = "BufReadPre",
	--	module = { "dap" },
	--	wants = {
	--		"nvim-dap-virtual-text",
	--		"nvim-dap-ui",
	--	},
	--	requires = {
	--		"theHamsta/nvim-dap-virtual-text",
	--		"rcarriga/nvim-dap-ui",
	--		"nvim-telescope/telescope-dap.nvim",
	--	},
	--	config = function()
	--		require("plugins.configs.dap").setup()
	--	end,
	--},

	-- 错误quickfix展示栏
	{
		"folke/trouble.nvim",
		setup = function()
			require("plugins.coding.trouble")
		end,
		-- require("core.keymaps").trouble_setup()
	},
	----------------------------------------------------
	-- NOTE: PUT ABOUT ==BEAUTIFY== THIRD PLUGIN HERE --
	----------------------------------------------------
	-- 透明度
	{
		"xiyaowong/transparent.nvim",
	},

	--------------------------------------------------------
	-- NOTE: PUT ABOUT ==FUNCTIONPLUS== THIRD PLUGIN HERE --
	--------------------------------------------------------
	-- StartupTime
	{
		"dstein64/vim-startuptime",
		opt = true,
		cmd = { "StartupTime" },
	},
}

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	--  use 'wbthomason/packer.nvim'

	-- My plugins here
	for _, v in pairs(plugins) do
		use(v)
	end

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
