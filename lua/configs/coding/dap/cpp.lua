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
	-- 1. 动态获取 Mason 安装的 codelldb 路径
	-- =========================================================================
	-- 这是一个很关键的步骤，因为不同系统 Mason 安装路径不一样
	local codelldb_pkg = mason_registry.get_package("codelldb")
	if not codelldb_pkg:is_installed() then
		-- 如果没装，提示一下用户
		vim.notify("CodeLLDB not installed via Mason!", vim.log.levels.WARN)
		return
	end

	local extension_path = codelldb_pkg:get_install_path() .. "/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"

	-- Windows 下需要加 .exe 后缀
	if vim.fn.has("win32") == 1 then
		codelldb_path = extension_path .. "adapter\\codelldb.exe"
	end

	-- =========================================================================
	-- 2. 定义适配器 (Adapter)
	-- =========================================================================
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}", -- [重要] 让 Neovim 自动随机分配端口，防止冲突
		executable = {
			command = codelldb_path,
			args = { "--port", "${port}" },
			-- On windows you may have to uncomment this:
			-- detached = false,
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
			-- 动态输入可执行文件路径
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false, -- 设为 false，直接运行到断点；设为 true 会停在 main 函数第一行
		},
		{
			-- 如果你需要带参数调试，选这个配置
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
