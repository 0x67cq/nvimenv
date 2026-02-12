return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI 界面
			{
				"rcarriga/nvim-dap-ui",
				dependencies = {
					"nvim-neotest/nvim-nio", -- [必须] dap-ui 现在的强依赖
				},
			},
			-- 虚拟文本 (在代码行旁边显示变量值)
			"theHamsta/nvim-dap-virtual-text",
			-- Mason 集成 (自动安装调试器)
			"jay-babu/mason-nvim-dap.nvim",
			-- Go 语言调试增强工具
			"leoluz/nvim-dap-go",
		},
		keys = {
			-- 常用快捷键
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- 1. 初始化 UI
			dapui.setup()

			-- 2. 自动开启/关闭 UI (监听调试事件)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- 3. 配置 Mason-DAP (自动安装调试器)
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = {
					"delve", -- Go 调试器
					"codelldb", -- C/C++/Rust 调试器
				},
			})

			-- 4. 配置虚拟文本
			require("nvim-dap-virtual-text").setup()

			-- 5. [核心] 自定义图标 (替代 LazyVim 的配置)
			local icons = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = { " ", "DiagnosticInfo" },
				BreakpointCondition = { " ", "DiagnosticInfo" },
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = { ".>", "DiagnosticInfo" },
			}

			-- 设置高亮行颜色
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(icons) do
				vim.fn.sign_define("Dap" .. name, {
					text = sign[1],
					texthl = sign[2],
					linehl = sign[3],
					numhl = sign[3],
				})
			end

			-- 6. 加载语言配置
			-- 这里的路径对应我们下面要创建的文件
			require("configs.coding.dap.go").setup()
			require("configs.coding.dap.cpp").setup()
		end,
	},
}
