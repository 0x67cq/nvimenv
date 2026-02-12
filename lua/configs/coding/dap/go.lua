--[[ 🟢 场景 A：调试带参数的程序
假设你的 Go 程序需要运行 go run main.go --env=prod --user=admin。
    在 main.go 打断点 (<leader>db)。
    按 <leader>dc (Continue)。
    在弹出的列表里选择 Debug with Args。
    在顶部输入框输入：--env=prod --user=admin，回车。
    开始调试。
🟢 场景 B：远程调试 (Docker/服务器)
假设你在服务器上启动了 dlv： dlv debug --headless --listen=:8181 --api-version=2
    在本地 Neovim 启动调试。
    选择 Attach Remote (127.0.0.1:8181)。
    直接连接到服务器进程，本地断点生效。 ]]
local M = {}

function M.setup()
	local dap = require("dap")
	local status_ok, dap_go = pcall(require, "dap-go")
	if not status_ok then
		return
	end

	-- =========================================================================
	-- 1. 基础设置 (利用插件)
	-- =========================================================================
	-- dap-go 会自动配置 'dap.adapters.go'，并处理好 dlv 的路径和动态端口
	dap_go.setup({
		delve = {
			-- 默认端口配置，通常不需要改，插件会自动处理
			port = "${port}",
		},
	})

	-- =========================================================================
	-- 2. 辅助函数
	-- =========================================================================
	local get_args = function()
		-- 获取输入命令行参数
		local cmd_args = vim.fn.input("CommandLine Args: ")
		local params = {}
		-- 定义分隔符
		for param in string.gmatch(cmd_args, "[^%s]+") do
			table.insert(params, param)
		end
		return params
	end

	-- =========================================================================
	-- 3. 自定义配置 (追加到 dap-go 已有的配置中)
	-- =========================================================================
	-- dap-go 已经生成了一些基础配置 (如 "Debug", "Debug Test")
	-- 我们把你的 "Debug with Args" 和 "Remote" 加进去

	local extra_configs = {
		-- [自定义 1] 带参数调试
		{
			type = "go", -- 注意：dap-go 注册的 adapter 名字叫 "go"
			name = "Debug with Args",
			request = "launch",
			program = "${file}",
			args = get_args, -- 调用上面的输入函数
		},
		-- [自定义 2] 远程调试 (连接 Docker 或服务器)
		{
			type = "go",
			name = "Attach Remote (127.0.0.1:8181)",
			mode = "remote",
			request = "attach",
			connect = {
				host = "127.0.0.1", -- 远端 IP
				port = "8181", -- 远端 dlv 监听的端口
			},
			cwd = vim.fn.getcwd(), -- 关键：映射本地源码路径
			substitutePath = {
				-- 路径映射：如果本地和远程路径不一致，需要配置这个
				-- { from = "${workspaceFolder}", to = "/app" },
			},
		},
	}

	-- 将自定义配置合并到现有配置中
	for _, config in ipairs(extra_configs) do
		table.insert(dap.configurations.go, config)
	end
end

return M
