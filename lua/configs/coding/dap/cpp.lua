--[[ # 1. 在终端编译 (注意 -g)
gcc -g main.c -o main

# 2. 回到 Neovim
# 按 <leader>db 打断点
# 按 <leader>dc 启动调试
# 输入路径：/path/to/your/project/main
 ]]

local M = {}

function M.setup()
	local dap = require("dap")
	local mason_registry = require("mason-registry")

	-- =========================================================================
	-- 1. 获取 codelldb 路径 (直接使用原生标准路径，最稳定)
	-- =========================================================================
	local data_path = vim.fn.stdpath("data")
	local default_mason_path = data_path .. "/mason/packages/codelldb"

	local extension_path = default_mason_path .. "/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"

	-- 检查 Mason 是否就绪，仅用于发通知，不再依赖它的 API 获取路径
	local ok, codelldb_pkg = pcall(mason_registry.get_package, "codelldb")
	if not (ok and codelldb_pkg:is_installed()) then
		vim.schedule(function()
			vim.notify("CodeLLDB not fully loaded in Mason, using fallback path.", vim.log.levels.INFO)
		end)
	end

	-- Windows 环境兼容
	if vim.fn.has("win32") == 1 then
		codelldb_path = codelldb_path:gsub("/", "\\") .. ".exe"
	end

	-- =========================================================================
	-- 2. 定义适配器 (Adapter)
	-- =========================================================================
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = codelldb_path,
			args = { "--port", "${port}" },
		},
	}

	-- =========================================================================
	-- 3. 定义调试配置 (Configurations)
	-- =========================================================================
	dap.configurations.cpp = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
		{
			name = "Launch file with args",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = function()
				local args_str = vim.fn.input("Args: ")
				return vim.split(args_str, " +")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}

	-- C 和 Rust 复用 C++ 的配置
	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp
end

return M
