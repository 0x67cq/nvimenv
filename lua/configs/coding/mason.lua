local M = {}

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
-- 1. 自定义 UI 与基础设置
-- =============================================================================
local options = {
	install_root_dir = vim.fn.stdpath("data") .. "/mason",
	PATH = "prepend",
	ui = {
		border = "rounded", -- 改为 rounded 更有现代感
		width = 0.8,
		height = 0.9,
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
}

-- =============================================================================
-- 2. 待安装清单 (分类管理)
-- =============================================================================

-- LSP 服务器 (由 mason-lspconfig 管理)
local servers = {
	"clangd", -- C/C++
	"gopls", -- Go
	"lua_ls", -- Lua
	"bashls", -- Bash
	"rust_analyzer", -- Rust
	"svelte", -- Svelte
	"html", -- HTML
	"cssls", -- CSS
	"ts_ls", -- TypeScript/JS
}

-- 格式化、代码检查与调试器 (由 mason-tool-installer 管理)
local extra_tools = {
	-- Formatters
	"prettier", -- 前端通用格式化
	"goimports", -- Go 自动导包
	"stylua", -- Lua 格式化

	-- Linters (代码质量检查)
	"golangci-lint", -- Go
	"eslint_d", -- 前端 (快速版)
	"shellcheck", -- Shell
	"selene", -- Lua

	-- Debuggers
	"delve", -- Go 调试器
}

-- =============================================================================
-- 3. 主 Setup 函数
-- =============================================================================
function M.setup()
	-- 加载 Mason 核心
	local mason_ok, mason = pcall(require, "mason")
	if not mason_ok then
		return
	end
	-- mason.setup(options)
	mason.setup(DEFAULT_SETTINGS) -- 假设 DEFAULT_SETTINGS 在你文件上方已定义

	-- 加载 Mason-LSPConfig
	local mlsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if mlsp_ok then
		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = true,
		})
	end

	-- 加载 Mason-Tool-Installer (自动化安装非 LSP 工具)
	local mti_ok, tool_installer = pcall(require, "mason-tool-installer")
	if mti_ok then
		tool_installer.setup({
			ensure_installed = extra_tools,
			auto_update = true,
			run_on_start = true,
		})
	end
end

return M
