-- comment this if you do not want to open nvim with a dir
--vim.cmd([[ autocmd BufEnter * if &buftype != "terminal" | lcd %:p:h | endif ]])
-- vim.cmd([[ autocmd BufEnter * if &buftype != "terminal" | endif ]])

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- vim.cmd([[ au InsertEnter * set norelativenumber ]])
-- vim.cmd([[ au InsertLeave * set relativenumber ]])
-- vim.cmd([[ autocmd WinEnter * if &number | execute("setlocal number relativenumber") | endif ]])
-- vim.cmd([[ autocmd WinLeave * if &number | execute("setlocal number norelativenumber") | endif ]])

-- Don't show any numbers inside terminals
-- vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])

-- FIX: Iterm2 光标不闪烁
-- vim.cmd([[ au VimLeave * set guicursor=a:ver25-blinkon1 ]])

-- Open a file from its last left off position
-- vim.cmd(
-- [[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
-- )
--
-- vim.cmd([[autocmd! FileType qf nnoremap <buffer> <C-v> <C-w><Enter><C-w>L]])

-- 自动格式化,null-ls代替了
-- vim.cmd [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.format({async=false}) vim.cmd.write()]]
--

local autocmd = vim.api.nvim_create_autocmd

-- 创建一个辅助函数来生成 Group，防止重复加载
local function augroup(name)
	return vim.api.nvim_create_augroup("my_autocmds_" .. name, { clear = true })
end

-----------------------------------------------------------
-- 1. 基础体验增强
-----------------------------------------------------------

-- [复制高亮] 复制文本时闪烁一下 (极度推荐)
autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})
-- [恢复光标] 打开文件时回到上次编辑的位置，并居中显示
autocmd("BufReadPost", {
	group = augroup("restore_cursor"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)

		-- 只有当位置合法时才跳转
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)

			-- [新增] 执行 'zz' 命令，强制将光标所在行移动到屏幕中间
			vim.cmd("normal! zz")
		end
	end,
})

-- [窗口调整] 当终端窗口大小改变时，自动调整分割比例
autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-----------------------------------------------------------
-- 2. 特定文件类型设置 (解决 Go vs Frontend 缩进冲突)
-----------------------------------------------------------

-- [Go & Makefile] 强制使用 Tab 缩进，且宽度为 4
autocmd("FileType", {
	group = augroup("go_format"),
	pattern = { "go", "gomod", "make" },
	callback = function()
		vim.opt_local.expandtab = false -- 不转空格
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- [终端设置] 进入 Terminal 模式时不显示行号，并自动进入插入模式
autocmd("TermOpen", {
	group = augroup("terminal_settings"),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.cmd("startinsert")
	end,
})

-----------------------------------------------------------
-- 3. 智能行号切换 (如果你喜欢 Insert 模式变绝对行号)
-----------------------------------------------------------
-- 如果你觉得切换时界面抖动，可以注释掉这一块
local number_toggle_group = augroup("number_toggle")

autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = number_toggle_group,
	callback = function()
		if vim.opt.number:get() and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = number_toggle_group,
	callback = function()
		if vim.opt.number:get() then
			vim.opt.relativenumber = false
		end
	end,
})

-----------------------------------------------------------
-- 4. 杂项修复
-----------------------------------------------------------

-- [iTerm2] 退出时恢复光标形状 (保留你原来的修复)
autocmd("VimLeave", {
	callback = function()
		vim.opt.guicursor = "a:ver25-blinkon1"
	end,
})
