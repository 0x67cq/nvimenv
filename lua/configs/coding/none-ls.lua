local M = {}

function M.setup()
	-- none-ls 依然沿用 "null-ls" 这个模块名，所以这里不用改
	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		return
	end

	-- 为了代码整洁，把 formatting 提取出来
	local formatting = null_ls.builtins.formatting
	local code_actions = null_ls.builtins.code_actions

	-- 创建一个 augroup，防止自动保存命令重复堆叠
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
		debug = true, -- 开启这一行
		log_level = "debug", -- 确保日志级别足够低
		sources = {
			-- 格式化工具
			formatting.shfmt, -- Shell
			formatting.prettier, -- JS/TS/HTML/CSS
			formatting.stylua, -- Lua
			-- formatting.rustfmt, -- Rust
			formatting.goimports_reviser, -- Go Imports

			-- 代码行为
			-- 注意：refactoring 通常需要依赖 Treesitter
			code_actions.refactoring,
		},

		-- [重构] 自动格式化逻辑 (适配 Neovim 0.11)
		on_attach = function(client, bufnr)
			-- 检查当前 LSP 是否支持格式化 (比直接查 server_capabilities 更安全)
			if client.supports_method("textDocument/formatting") then
				-- 1. 清除当前 buffer 旧的自动命令，防止重复
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

				-- 2. 创建新的自动命令
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						-- 3. 执行格式化
						-- async = false 确保在文件写入磁盘前格式化完成
						vim.lsp.buf.format({
							bufnr = bufnr,
							async = false,
							-- 可选：如果你只想用 none-ls 格式化，不想用其他 LSP (如 tsserver)
							-- filter = function(c) return c.name == "null-ls" end
						})
					end,
				})
			end
		end,
	})
end

return M
