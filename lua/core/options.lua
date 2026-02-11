local opt = vim.opt
local g = vim.g

-- 定义选项表
local options = {
	-- [UI 界面]
	number = true, -- 显示行号
	relativenumber = true, -- 相对行号 (方便 j/k 跳转)
	signcolumn = "yes", -- 始终显示左侧图标列 (防止代码抖动)
	cmdheight = 1, -- [建议改回 1] 命令行高度，0.10+ 推荐 0 或 1
	showmode = false, -- 不显示 -- INSERT -- (通常由 Lualine 接管)
	showtabline = 2, -- 始终显示标签页栏
	termguicolors = true, -- [0.10+ 已默认，可留可删] 真彩色支持
	cursorline = true, -- 高亮当前行
	pumheight = 10, -- 补全菜单最大高度

	-- [缩进与排版] (针对前端优化，Go 需要单独处理)
	expandtab = true, -- Tab 转空格
	shiftwidth = 2, -- 缩进宽度 2
	tabstop = 2, -- Tab 宽度 2
	smartindent = true, -- 智能缩进
	autoindent = true, -- 自动缩进
	wrap = false, -- 禁止自动换行

	-- [搜索与替换]
	ignorecase = true, -- 搜索忽略大小写
	smartcase = true, -- 如果输入大写则敏感
	hlsearch = true, -- 高亮搜索结果

	-- [系统行为]
	clipboard = "unnamedplus", -- 与系统剪贴板同步
	mouse = "a", -- 启用鼠标
	undofile = true, -- 开启持久化撤销 (退出重进还能撤销)
	swapfile = false, -- 禁用 swap 文件
	backup = false, -- 禁用 backup
	writebackup = false,
	timeoutlen = 500, -- 快捷键延迟 (毫秒)
	updatetime = 300, -- 悬停更新时间 (影响 LSP 显示)

	-- [窗口分割]
	splitbelow = true, -- 新窗口在下
	splitright = true, -- 新窗口在右

	-- [滚动体验]
	scrolloff = 8, -- 光标距离页边保留 8 行
	sidescrolloff = 8,
}

-- 应用选项
for k, v in pairs(options) do
	opt[k] = v
end

-- [特殊追加配置]
opt.shortmess:append("c") -- 隐藏很多无用的补全消息
opt.whichwrap:append("<>[]hl") -- 允许光标左右移动跨行

-- [禁用内置插件]
-- 主要是为了加快启动速度，或者避免与 nvim-tree/neo-tree 冲突
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	-- "matchit",  <-- [强烈建议注释掉] 除非你装了 vim-matchup，否则保留这个很有用
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end
