local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	--[[ ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages ]]
	-- ensure_installed = {"vim", "javascript", "typescript", "tsx"},
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"bash",
		"go",
		"rust",
		"python",
		"svelte",
		"javascript",
		"typescript",
		"html",
		"css",
	},
	sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		-- disable = { "yaml" },
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	-- context_commentstring = {
	--   enable = true,
	--   config = {
	--     -- Languages that have a single comment style
	--     typescript = "// %s",
	--     css = "/* %s */",
	--     scss = "/* %s */",
	--     html = "<!-- %s -->",
	--     svelte = "<!-- %s -->",
	--     vue = "<!-- %s -->",
	--     json = "",
	--   },
	-- },
	matchup = {
		enable = true, -- mandatory, false will disable the whole extension
		-- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
		-- [options]
	},
	-- rainbow = {
	--   enable = true,
	--   -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
	--   extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
	--   max_file_lines = nil, -- Do not enable for files with more than n lines, int
	--   -- colors = {}, -- table of hex strings
	--   -- termcolors = {} -- table of colour name strings
	-- },
	autotag = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			node_decremental = "<BS>",
			scope_incremental = "<TAB>",
		},
	},
})

-- 开启折叠功能 zc 折叠 zo 打开
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.opt.foldlevel = 99
