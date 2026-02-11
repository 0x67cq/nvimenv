local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

-- =============================================================================
-- 快捷键设置 (Keymaps)
-- =============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "Bufferline" }

-- 切换标签
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", opts) -- 下一个
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", opts) -- 上一个

-- 移动标签位置 (比如把第3个移到第2个)
map("n", "<leader>bnn", "<cmd>BufferLineMoveNext<CR>", opts)
map("n", "<leader>bpp", "<cmd>BufferLineMovePrev<CR>", opts)

-- 快速跳转 (Leader + 1~9)
map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", opts)
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", opts)
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", opts)
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", opts)
map("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", opts)
map("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", opts)
map("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", opts)
map("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", opts)
map("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", opts)

-- 关闭当前 (建议用这个代替 :bd，更安全)
map("n", "<leader>bd", "<cmd>bdelete!<CR>", { desc = "Close Buffer" })

-- =============================================================================
-- 主配置 (Setup)
-- =============================================================================
bufferline.setup({
	options = {
		-- [核心修复] 必须是 buffers，否则你打开文件顶部不显示！
		mode = "buffers",

		-- 样式风格
		style_preset = bufferline.style_preset.default, -- 或者 .minimal
		theme = "gruvbox", -- 适配主题

		-- [核心] NvimTree 避让 (防止标签栏遮住左侧文件树)
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "center", -- "left" | "center" | "right"
				separator = true,
				padding = 1,
			},
		},

		-- 图标设置 (使用新版 Nerd Fonts)
		buffer_close_icon = "󰅖",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",

		-- 序号显示: "ordinal" (1,2,3...) 或 "buffer_id"
		numbers = "ordinal",

		-- [增强] 显示 LSP 错误诊断
		-- 当文件有错误时，标签页名字会变红，并显示图标
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,

		-- 鼠标左键点击切换，右键点击关闭
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		left_mouse_command = "buffer %d",

		-- 分隔符风格
		separator_style = "thin", -- "slant" | "thick" | "thin"

		-- 鼠标悬停显示关闭按钮
		show_buffer_close_icons = true,
		show_close_icon = true,
	},

	-- =========================================================================
	-- [关键] 透明背景高亮覆盖
	-- 这段代码会让 BufferLine 的背景完全透明，适配你的 Gruvbox
	-- =========================================================================
	highlights = {
		fill = {
			bg = "NONE",
		},
		background = {
			bg = "NONE",
		},
		tab = {
			bg = "NONE",
		},
		tab_selected = {
			bg = "NONE",
		},
		tab_close = {
			bg = "NONE",
		},
		separator = {
			fg = "NONE",
			bg = "NONE",
		},
		separator_selected = {
			bg = "NONE",
		},
		close_button = {
			bg = "NONE",
		},
		close_button_selected = {
			bg = "NONE",
		},
		buffer_visible = {
			bg = "NONE",
		},
		modified = {
			bg = "NONE",
		},
		modified_visible = {
			bg = "NONE",
		},
		modified_selected = {
			bg = "NONE",
		},
		-- 你可以根据需要继续添加...
	},
})
