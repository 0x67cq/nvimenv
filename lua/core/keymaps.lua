--[[ local utils = require("core.utils")

local map = utils.map
local nmap = utils.nmap
local imap = utils.imap

local cmd = vim.cmd

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local M = {}

M.init = function()
	---------------------- Leader ---------------------------

	map("", "<Space>", "<Nop>")
	vim.g.mapleader = ";"
	vim.g.maplocalleader = ";"

	-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
	-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
	-- empty mode is same as using :map
	-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
	map({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

	-- don't yank text on delete ( dd )
	-- map({ "n", "v" }, "d", '"_d')

	-------------------- Editor -----------------------
	nmap("H", "^")
	nmap("L", "$")

	-- ctrl u / ctrl + d  只移动9行，默认移动半屏
	nmap("<C-u>", "15k")
	nmap("<C-d>", "15j")

	-- nmap("<A-s>", ":w! <CR>")
	-- imap("<A-s>", "<ESC>:w! <CR>")
	-- nmap("<A-q>", ":q <CR>")
	-- Move text up and down
	-- map("v", "<A-j>", ":m .+1<CR>==")
	-- map("v", "<A-k>", ":m .-2<CR>==")
	-- map("x", "<A-j>", ":move '>+1<CR>gv-gv")
	-- map("x", "<A-k>", ":move '<-2<CR>gv-gv")
	-- 缩进
	map("v", "<", "<gv")
	map("v", ">", ">gv")

	----------------- Navigation ----------------------------
	-- navigation within insert mode
	imap("<A-h>", "<Left>")
	imap("<A-l>", "<Right>")
	imap("<A-k>", "<Up>")
	imap("<A-j>", "<Down>")
	imap("<A-S-l>", "<End>")
	imap("<A-S-h>", "<ESC>^i")

	-- easier navigation between windows
	nmap("<A-h>", "<C-w>h")
	nmap("<A-j>", "<C-w>j")
	nmap("<A-k>", "<C-w>k")
	nmap("<A-l>", "<C-w>l")

	------------ Windows ----------------------------
	-- 分屏
	nmap("<leader>v", ":vsp<CR>")
	nmap("<leader>h", ":sp<CR>")
	-- 关闭当前
	nmap("<leader>wc", "<C-w>c")
	-- 关闭其他
	nmap("<leader>wo", "<C-w>o") -- close others
	-- 相等比例
	nmap("<leader>w=", "<C-w>=")
	-- Resize with arrows
	nmap("<S-Up>", ":resize -2<CR>")
	nmap("<S-Down>", ":resize +2<CR>")
	nmap("<S-Left>", ":vertical resize -2<CR>")
	nmap("<S-Right>", ":vertical resize +2<CR>")
end

return M ]]

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

---------------------- 基础编辑体验 ----------------------

-- [命令行] 允许用 j/k 在视觉行之间移动 (处理自动换行的情况)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- [行首行尾] H/L 虽然原义是屏幕顶部/底部，但映射为行首/行尾也很流行
keymap({ "n", "v" }, "H", "^", opts)
keymap({ "n", "v" }, "L", "$", opts)

-- [翻页] 保持你的习惯，但调整一下步长
keymap("n", "<C-u>", "15k", opts)
keymap("n", "<C-d>", "15j", opts)

-- [缩进] 选中缩进后，保持选中状态 (非常实用！)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- [剪贴板] 粘贴时不复制被覆盖的内容 (这是很多人的痛点)
-- 比如你复制了 "A"，去替换 "B"，默认 vim 会把 "B" 放到剪贴板，导致你下次粘贴由于变成了 "B"
-- 开启下面这行可以解决：
-- keymap("x", "p", [["_dP]])

---------------------- 插入模式导航 (Emacs 风格) ----------------------
-- 让你在打字时手不用离开主键盘区就能微调光标
keymap("i", "<A-h>", "<Left>", opts)
keymap("i", "<A-l>", "<Right>", opts)
keymap("i", "<A-k>", "<Up>", opts)
keymap("i", "<A-j>", "<Down>", opts)
keymap("i", "<A-S-l>", "<End>", opts)
keymap("i", "<A-S-h>", "<Esc>^i", opts)

---------------------- 窗口管理 (Windows) ----------------------

-- [窗口导航] Alt + hjkl (强烈推荐配合 nvim-tmux-navigator 插件)
keymap("n", "<A-h>", "<C-w>h", opts)
keymap("n", "<A-j>", "<C-w>j", opts)
keymap("n", "<A-k>", "<C-w>k", opts)
keymap("n", "<A-l>", "<C-w>l", opts)

-- [窗口操作]
-- 建议使用 Leader 键，避免占用 s 键
keymap("n", "<leader>sv", ":vsp<CR>", { desc = "Split Vertically" })
keymap("n", "<leader>sh", ":sp<CR>", { desc = "Split Horizontally" })
keymap("n", "<leader>sc", "<C-w>c", { desc = "Close Window" }) -- 对应你的 sc
keymap("n", "<leader>so", "<C-w>o", { desc = "Close Others" }) -- 对应你的 so

-- [调整大小] 使用方向键调整窗口大小
keymap("n", "<S-Up>", ":resize -2<CR>", opts)
keymap("n", "<S-Down>", ":resize +2<CR>", opts)
keymap("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- [取消高亮] 按 ESC 取消搜索高亮 (非常常用)
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)
