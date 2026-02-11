local present, trouble = pcall(require, "trouble")

if not present then
	return
end

-- =============================================================================
-- Keymaps (适配 Trouble v3 API)
-- =============================================================================

-- 辅助函数：简化 toggle 调用
local function toggle(mode, opts)
	return function()
		trouble.toggle(vim.tbl_extend("force", { mode = mode }, opts or {}))
	end
end

-- =============================================================================
-- Setup (适配 Trouble v3 配置结构)
-- =============================================================================

trouble.setup({
	-- 窗口设置 (原 position, height, width)
	win = {
		type = "split", -- split (下方/上方), float (浮动)
		position = "bottom", -- bottom, top, left, right
		size = 10, -- 原 height = 10
		-- border = "rounded", -- 如果想要圆角边框可以解开注释
	},

	-- 图标与标志设置 (原 signs, icons)
	icons = {
		indent = {
			fold_open = "",
			fold_closed = "",
		},
		folder_closed = "",
		folder_open = "",
		kinds = {
			-- 对应你原来的 signs 配置
			Error = "E",
			Warning = "",
			Hint = "H",
			Information = "",
			Other = "O",
		},
	},

	-- 行为设置
	focus = true, -- 打开时自动聚焦窗口
	follow = true, -- 列表滚动时跟随光标
	auto_close = false, -- 跳转后不自动关闭
	auto_preview = false, -- 你原来设置了 false

	-- 快捷键设置 (原 action_keys)
	-- 格式: ["按键"] = "动作名称"
	keys = {
		["q"] = "close",
		["<esc>"] = "cancel",
		["r"] = "refresh",
		["<cr>"] = "jump",
		["<tab>"] = "jump",
		["<c-x>"] = "jump_split", -- 原 open_split
		["<c-v>"] = "jump_vsplit", -- 原 open_vsplit
		["<c-t>"] = "jump_tab", -- 原 open_tab
		["o"] = "jump_close", -- 跳转并关闭
		["P"] = "toggle_preview",
		["K"] = "inspect", -- 悬浮显示完整信息 (原 hover)
		["p"] = "preview", -- 预览位置
		["zM"] = "fold_close_all", -- 原 close_folds
		["zR"] = "fold_open_all", -- 原 open_folds
		["zA"] = "fold_toggle", -- 原 toggle_fold
		["k"] = "prev", -- 原 previous
		["j"] = "next", -- 原 next
	},

	-- 模式特定配置 (可选)
	modes = {
		-- 例如：lsp 引用模式下自动展开
		lsp_references = {
			auto_refresh = false,
			fold_open = true,
		},
	},
})
