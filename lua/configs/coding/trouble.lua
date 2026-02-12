local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
	return
end

trouble.setup({
	-- [1] 窗口外观
	win = {
		type = "split", -- 使用分割窗口
		position = "bottom", -- 也就是 Quickfix 的位置
		size = 10, -- 高度
		-- border = "rounded", -- 如果你想要浮窗圆角，把 type 改成 float 并解开这个
	},

	-- [2] 行为设置
	focus = true, -- 打开窗口时自动聚焦进去
	follow = true, -- 列表滚动时，预览窗口自动跟随
	auto_close = false, -- 跳转后不自动关闭 (改为 true 则跳完就关)

	-- [3] 图标设置 (使用默认的 Nerd Fonts，比文本 'E' 好看)
	-- 如果你非要改回文本，可以在这里覆盖，但我建议保留默认
	icons = {
		indent = {
			top = "│ ",
			middle = "├╴",
			last = "└╴",
			fold_open = " ",
			fold_closed = " ",
			ws = "  ",
		},
		folder_closed = " ",
		folder_open = " ",
		kinds = {
			Error = " ",
			Warning = " ",
			Hint = " ",
			Information = " ",
		},
	},

	-- [4] 按键映射 (v3 版本)
	-- Trouble 默认已经有 j/k/q/Esc/Enter 了，这里只添加你习惯的特殊键
	keys = {
		-- 基础操作
		["q"] = "close",
		["<esc>"] = "close", -- 我习惯按 esc 直接关，而不是 cancel
		["<cr>"] = "jump", -- 回车跳转

		-- 分屏跳转 (你的习惯)
		["<c-x>"] = "jump_split", -- 水平分屏打开
		["<c-v>"] = "jump_vsplit", -- 垂直分屏打开
		["<c-t>"] = "jump_tab", -- 新标签页打开

		-- 预览和详情
		["P"] = "toggle_preview", -- 开启/关闭预览
		["K"] = "preview", -- 悬浮显示完整报错信息

		-- 折叠操作
		["za"] = "fold_toggle",
		["zM"] = "fold_close_all",
		["zR"] = "fold_open_all",
	},
})
