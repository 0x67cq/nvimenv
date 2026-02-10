local M = {}

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
function M.setup()
	-- 1. Setup Mason
	local status_ok, mason = pcall(require, "mason")
	if not status_ok then
		return
	end

	local status_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_lsp then
		return
	end

	mason.setup(DEFAULT_SETTINGS)

	local servers = { "clangd", "gopls", "lua_ls", "bashls", "rust_analyzer" }

	mason_lspconfig.setup({
		ensure_installed = servers,
	})

	-- 2. 准备 Capabilities
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local status_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_cmp then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	-- 3. 手动定义服务器配置
	local manual_configs = {
		clangd = {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			root_dir = find_root({
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				".git",
			}),
		},
		gopls = {
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = find_root({ "go.work", "go.mod", ".git" }),
		},
		lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_dir = find_root({ ".luarc.json", ".luacheckrc", ".git" }),
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
				},
			},
		},
		bashls = {
			cmd = { "bash-language-server", "start" },
			filetypes = { "sh", "bash" },
			root_dir = find_root({ ".git" }),
		},
		rust_analyzer = {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_dir = find_root({ "Cargo.toml", "rust-project.json", ".git" }),
		},
	}

	-- 4. 应用配置并启动
	for server_name, config in pairs(manual_configs) do
		config.capabilities = capabilities
		vim.lsp.config[server_name] = config
		vim.lsp.enable(server_name)
	end
end

return M
