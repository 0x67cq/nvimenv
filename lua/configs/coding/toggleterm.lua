local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

local m = {
	toggle = [[<c-\>]],
	-- [关键优化] 终端内的导航快捷键
	close = [[<C-\><C-n>]], -- 建议不直接用 <ESC>，否则终端内的程序(如 vi)无法接收 ESC
	left = "<C-h>",
	down = "<C-j>",
	up = "<C-k>",
	right = "<C-l>",
}

toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	open_mapping = m.toggle,
	hide_numbers = true,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "horizontal", -- 默认底部开启
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved", -- 圆角边框，适配你的 UI
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

-- =============================================================================
-- 终端模式按键映射 (解决窗口跳转问题)
-- =============================================================================
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	-- 在终端里按 jk 快速切回 Normal 模式
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	-- 在终端里直接用 Ctrl + hjkl 跨窗口跳转，不用先退出插入模式
	vim.keymap.set("t", m.left, [[<C-\><C-n><C-W>h]], opts)
	vim.keymap.set("t", m.down, [[<C-\><C-n><C-W>j]], opts)
	vim.keymap.set("t", m.up, [[<C-\><C-n><C-W>k]], opts)
	vim.keymap.set("t", m.right, [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- =============================================================================
-- 自定义终端：Lazygit / Htop
-- =============================================================================
local Terminal = require("toggleterm.terminal").Terminal

-- Lazygit (浮窗模式)
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,
	direction = "float",
	float_opts = { border = "double" },
	-- 只有这个窗口不设 jk 映射，因为 lazygit 需要用 j/k
})
vim.keymap.set("n", "<leader>tg", function()
	lazygit:toggle()
end, { desc = "LazyGit" })

-- Htop (浮窗模式)
local htop = Terminal:new({
	cmd = "htop",
	hidden = true,
	direction = "float",
})
vim.keymap.set("n", "<leader>th", function()
	htop:toggle()
end, { desc = "Htop" })

-- 你之前的 Python 也可以类似设置
-- vim.keymap.set("n", "<leader>py", function() python:toggle() end)
