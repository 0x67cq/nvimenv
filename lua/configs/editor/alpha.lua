local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")

-- =============================================================================
-- 1. 头部 ASCII 艺术 (摇曳露营 - 富士山与帐篷)
-- =============================================================================

dashboard.section.header.val = {
	[[                                             ]],
	[[             , - ~ ~ ~ - ,                 ]],
	[[         , '       +       ' ,             ]],
	[[       ,      (       /\   +   ,           ]],
	[[      /      .       /  \       \          ]],
	[[     |   /\         /    \__     |         ]],
	[[     |  /  \       /        \  . |         ]],
	[[     | /_/\_\     /   /\     \   |   ) (   ]],
	[[     |   ||      /   /  \     \  |  ( ) )  ]],
	[[     |   ||     /   / /\ \     \ | ( \ / ) ]],
	[[     |_ _||____/__ / /__\ \ ____\|  \_X_/  ]],
	[[     | .   ~      /______\ \ .   .    .  | ]],
	[[     |  .    ~~~~      .    ~      .   . | ]],
	[[      \   ~ .    ~~~~      ~    ~~~~    /  ]],
	[[       ' ,     .      ~~~~   . ~      , '  ]],
	[[           ' - , _ _ _ _ _ _ _ , - '       ]],
	[[                                           ]],
	[[             A D V E N T U R E             ]],
	[[                                           ]],
}

-- 设置头部颜色 (推荐用 Type/Function/String 这种自然色)
dashboard.section.header.opts.hl = "Type"

-- =============================================================================
-- 2. 按钮菜单 (美化图标)
-- =============================================================================
-- 辅助函数：让快捷键显示在右侧，看起来更像 IDE
local function button(sc, txt, keybind, keybind_opts)
	local b = dashboard.button(sc, txt, keybind, keybind_opts)
	b.opts.hl = "Keyword" -- 按钮图标高亮
	b.opts.hl_shortcut = "Number" -- 快捷键高亮
	return b
end

dashboard.section.buttons.val = {
	button("f", "  Find File", ":Telescope find_files <CR>"),
	button("n", "  New File", ":ene <BAR> startinsert <CR>"),
	button("p", "  Find Project", ":lua require('telescope').extensions.project.project{}<CR>"),
	button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
	button("t", "  Find Text", ":Telescope live_grep <CR>"),
	button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
	button("q", "  Quit", ":qa<CR>"),
}

-- =============================================================================
-- 3. 底部 Footer
-- =============================================================================
local function footer()
	local datetime = os.date("  %Y-%m-%d   %H:%M:%S")
	return {
		datetime,
		"",
		"又不是不能用 🐶",
	}
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Comment"

-- =============================================================================
-- 4. 布局调整
-- =============================================================================
-- 调整间距，让画面更居中协调
dashboard.config.layout = {
	{ type = "padding", val = 2 },
	dashboard.section.header,
	{ type = "padding", val = 2 },
	dashboard.section.buttons,
	{ type = "padding", val = 1 },
	dashboard.section.footer,
}

-- 禁止 Alpha 页面触发自动命令 (比如自动列出目录等)
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)
