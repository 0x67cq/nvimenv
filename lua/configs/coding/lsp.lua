local M = {}
local lsp_util = require("lspconfig.util")

-- =============================================================================
-- Keymaps
-- =============================================================================
vim.keymap.set("n", "<leader>jv", ":vsplit | lua vim.lsp.buf.definition()<Enter>")
vim.keymap.set(
	"n",
	"<leader>js",
	":belowright split | lua vim.lsp.buf.definition()<CR>",
	{ noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.declaration()<CR>")

vim.keymap.set("n", "<leader>g", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "<leader>gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "<leader>gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>')
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "<leader>gf", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "<leader>[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "<leader>]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "<leader>gsl", "<cmd>lua vim.diagnostic.setloclist()<CR>")
vim.keymap.set("n", "<leader>bf", "<cmd>lua vim.lsp.buf.format({ async = true }) vim.cmd.write() <CR>")

-- =============================================================================
-- Mason Settings
-- =============================================================================
local DEFAULT_SETTINGS = {
	install_root_dir = vim.fn.stdpath("data") .. "/mason",
	PATH = "prepend",
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
	registries = { "github:mason-org/mason-registry" },
	providers = { "mason.providers.registry-api", "mason.providers.client" },
	github = { download_url_template = "https://github.com/%s/releases/download/%s/%s" },
	pip = { upgrade_pip = false, install_args = {} },
	ui = {
		check_outdated_packages_on_open = true,
		border = "none",
		width = 0.8,
		height = 0.9,
		icons = { package_installed = "◍", package_pending = "◍", package_uninstalled = "◍" },
		keymaps = {
			toggle_package_expand = "<CR>",
			install_package = "i",
			update_package = "u",
			check_package_version = "c",
			update_all_packages = "U",
			check_outdated_packages = "C",
			uninstall_package = "X",
			cancel_installation = "<C-c>",
			apply_language_filter = "<C-f>",
		},
	},
}

-- =============================================================================
-- [FIXED] 辅助函数: Root Directory 查找
-- =============================================================================
local function find_root(markers)
	return function(info)
		-- 核心修复：处理 info 为 buffer number 的情况
		local path = info
		if type(info) == "number" then
			path = vim.api.nvim_buf_get_name(info)
		end

		-- 安全检查：防止 path 为空导致 vim.fs.find 报错
		if not path or path == "" then
			path = vim.fn.getcwd()
		end

		local found = vim.fs.find(markers, { path = path, upward = true })[1]
		if found then
			return vim.fs.dirname(found)
		end
		return nil
	end
end

-- =============================================================================
-- Setup Function
-- =============================================================================
--
--

function M.setup()
	-- 1. Setup Mason (保持不变，用于下载二进制文件)
	local status_ok, mason = pcall(require, "mason")
	if not status_ok then
		return
	end

	local status_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_lsp then
		return
	end

	mason.setup(DEFAULT_SETTINGS) -- 假设 DEFAULT_SETTINGS 在你文件上方已定义

	local servers = { "clangd", "gopls", "lua_ls", "bashls", "rust_analyzer" }

	mason_lspconfig.setup({
		ensure_installed = servers,
	})

	-- 2. 准备 Capabilities (代码补全能力)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local status_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_cmp then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	-- 3. 定义服务器详细配置 (全量配置，不依赖插件默认值)
	-- 注意：cmd 中的命令只需写名称，Mason 会自动处理 PATH
	local server_configs = {
		clangd = {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			root_dir = lsp_util.root_pattern(".clangd", ".clang-tidy", "compile_commands.json", ".git"),
		},
		gopls = {
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = lsp_util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = { unusedparams = true },
				},
			},
		},
		lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_dir = lsp_util.root_pattern(".luarc.json", ".luacheckrc", ".git"),
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
				},
			},
		},
		-- 显式补全 bashls 配置
		bashls = {
			cmd = { "bash-language-server", "start" },
			filetypes = { "sh", "bash" },
			root_dir = lsp_util.root_pattern(".git"),
		},
		-- 显式补全 rust_analyzer 配置
		rust_analyzer = {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_dir = lsp_util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
		},
	}

	-- 4. [核心修复] 使用原生 Autocmd + vim.lsp.start 启动服务
	-- 这完全绕过了废弃的 lspconfig setup 框架
	for server_name, config in pairs(server_configs) do
		-- 必须有 filetypes 才能创建自动命令
		if config.filetypes then
			vim.api.nvim_create_autocmd("FileType", {
				pattern = config.filetypes,
				callback = function(args)
					-- 1. 查找 Root Directory
					local root_dir = nil
					if config.root_dir then
						-- lsp_util.root_pattern 返回的是一个函数，传入文件名执行
						root_dir = config.root_dir(vim.api.nvim_buf_get_name(args.buf))
					end

					-- 如果找不到 root (比如单文件模式)，有些 LSP 可能需要当前目录作为 root
					if not root_dir then
						root_dir = vim.fn.getcwd()
					end

					-- 2. 启动/连接 LSP 客户端
					vim.lsp.start({
						name = server_name,
						cmd = config.cmd,
						root_dir = root_dir,
						settings = config.settings,
						capabilities = capabilities,
						-- on_attach 可以在这里添加，如果需要的话
					})
				end,
			})
		end
	end
end

return M
